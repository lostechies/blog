#!/usr/bin/env node

// Phase 5 link verification: extracts every internal link from the Hugo build
// (both post bodies and templates) and confirms each target resolves as a page,
// file, or alias. Cross-references the golden build so pre-existing broken links
// (broken on the live Jekyll site too) are reported separately from regressions
// introduced by the migration.
//
// Resolution mirrors GitHub Pages:
//   /foo    -> /foo, /foo.html, or /foo/index.html
//   /foo/   -> /foo/index.html
//
// Percent-encoded paths are decoded before lookup, and links to either the apex
// or www host are treated as internal (www redirects to the apex deployment).
//
// Usage: node scripts/verify_links.mjs

import { readFileSync, readdirSync, writeFileSync, statSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SITE = resolve(HERE, "../_site");
const PUBLIC = resolve(HERE, "../public");
const GOLDEN_PAGES = resolve(HERE, "../migration/golden_pages.txt");
const GOLDEN_ALIASES = resolve(HERE, "../migration/golden_aliases.txt");
const GOLDEN_FILES = resolve(HERE, "../migration/golden_files.txt");
const REPORT = resolve(HERE, "../migration/link_report.txt");

// Sort by UTF-8 bytes so report ordering is stable and locale-independent.
function compareBytes(a, b) {
  return Buffer.compare(Buffer.from(a, "utf8"), Buffer.from(b, "utf8"));
}

// Decode only valid %XX escapes, interpreting decoded bytes as UTF-8.
function unescape(str) {
  const re = /%[0-9a-fA-F]{2}/g;
  const parts = [];
  let last = 0;
  let match;
  while ((match = re.exec(str)) !== null) {
    parts.push(Buffer.from(str.slice(last, match.index), "utf8"));
    parts.push(Buffer.from([parseInt(match[0].slice(1), 16)]));
    last = match.index + match[0].length;
  }
  parts.push(Buffer.from(str.slice(last), "utf8"));
  return Buffer.concat(parts).toString("utf8");
}

function readLines(path) {
  const lines = readFileSync(path, "utf8").split("\n");
  if (lines.length > 0 && lines[lines.length - 1] === "") lines.pop();
  return lines;
}

// Skip dotfiles so build metadata never enters the inventory.
function inventory(dir) {
  const files = new Set();
  const walk = (current) => {
    let entries;
    try {
      entries = readdirSync(current, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      if (entry.name.startsWith(".")) continue;
      const full = join(current, entry.name);
      if (entry.isDirectory()) walk(full);
      else files.add(relative(dir, full));
    }
  };
  walk(dir);
  return files;
}

function htmlFiles(dir) {
  const found = [];
  const walk = (current) => {
    let entries;
    try {
      entries = readdirSync(current, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      if (entry.name.startsWith(".")) continue;
      const full = join(current, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.name.endsWith(".html")) found.push(full);
    }
  };
  walk(dir);
  return found.sort(compareBytes);
}

export function resolvable(files, target) {
  const path = unescape(target.replace(/^\//, ""));
  if (target.endsWith("/")) return files.has(`${path}index.html`);

  return (
    files.has(path) ||
    files.has(`${path}.html`) ||
    files.has(`${path}/index.html`)
  );
}

// Returns [kind, url], where kind is "internal", "external", or "skip".
export function classify(raw) {
  if (/^(#|mailto:|javascript:)/.test(raw)) return ["skip", null];

  const url = raw
    .replace(/^(https?:)?\/\/(?:www\.)?lostechies\.com(?=\/|$)/, "")
    .replace(/(#|\?).*/, "");
  if (url === "") return ["skip", null];
  if (url.startsWith("//")) return ["external", url];
  if (!url.startsWith("/")) return ["skip", null];

  return ["internal", url];
}

export function run() {
  const hugoFiles = inventory(PUBLIC);
  const goldenFiles = new Set([
    ...inventory(SITE),
    ...readLines(GOLDEN_FILES),
    ...readLines(GOLDEN_PAGES).map((line) => line.replace(/^\//, "")),
    ...readLines(GOLDEN_ALIASES).map((line) =>
      line.split("\t")[0].replace(/^\//, ""),
    ),
  ]);

  const links = new Map(); // link -> count
  const brokenHugo = new Set();
  const brokenBoth = new Set();
  const external = new Set();

  for (const path of htmlFiles(PUBLIC)) {
    const html = readFileSync(path, "utf8");
    for (const match of html.matchAll(/href="([^"]+)"/g)) {
      const [kind, url] = classify(match[1]);
      if (kind === "external") external.add(url);
      else if (kind === "internal") links.set(url, (links.get(url) ?? 0) + 1);
    }
  }

  for (const url of [...links.keys()].sort(compareBytes)) {
    if (resolvable(hugoFiles, url)) continue;
    brokenHugo.add(url);
    if (resolvable(goldenFiles, url)) brokenBoth.add(url);
  }

  const preExisting = [...brokenHugo].filter((url) => !brokenBoth.has(url));
  const lines = [
    `total internal link targets: ${links.size}`,
    `broken in Hugo build: ${brokenHugo.size}`,
    `  of which ALSO broken on live Jekyll (pre-existing): ${preExisting.length}`,
    `  REGRESSIONS (worked on live, broken in Hugo): ${brokenBoth.size}`,
    `protocol-relative external targets skipped: ${external.size}`,
    "",
    "-- regressions --",
    ...[...brokenBoth]
      .sort(compareBytes)
      .map((url) => `${links.get(url)}\t${url}`),
    "",
    "-- pre-existing broken (on live too) --",
    ...preExisting.sort(compareBytes).map((url) => `${links.get(url)}\t${url}`),
  ];
  writeFileSync(REPORT, `${lines.join("\n")}\n`);

  console.log(
    `targets: ${links.size}  broken in hugo: ${brokenHugo.size}  regressions: ${brokenBoth.size}`,
  );
  console.log(`external targets skipped: ${external.size}`);
  console.log(`report: ${REPORT}`);
  process.exit(brokenBoth.size === 0 ? 0 : 1);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  run();
}
