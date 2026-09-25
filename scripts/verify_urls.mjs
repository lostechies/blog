#!/usr/bin/env node

// Phase 5 verification: compares the Hugo build (public/) against the golden
// Jekyll contract in migration/.
//
// Checks:
//   1. Canonical pages: every golden page URL must exist in the Hugo build.
//   2. Aliases: every golden alias URL must exist as an alias page in Hugo.
//   3. Files: media/asset parity.
//
// Usage: node scripts/verify_urls.mjs

import { readFileSync, readdirSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const MIGRATION = resolve(HERE, "../migration");
const PUBLIC = resolve(HERE, "../public");

// Sort by UTF-8 bytes so output ordering is stable and locale-independent.
function compareBytes(a, b) {
  return Buffer.compare(Buffer.from(a, "utf8"), Buffer.from(b, "utf8"));
}

function readLines(path) {
  const lines = readFileSync(path, "utf8").split("\n");
  if (lines.length > 0 && lines[lines.length - 1] === "") lines.pop();
  return lines;
}

function walk(dir) {
  const found = [];
  let entries;
  try {
    entries = readdirSync(dir, { withFileTypes: true });
  } catch {
    return found;
  }
  for (const entry of entries) {
    if (entry.name.startsWith(".")) continue;
    const full = join(dir, entry.name);
    if (entry.isDirectory()) found.push(...walk(full));
    else found.push(full);
  }
  return found;
}

const goldenPages = new Set(readLines(join(MIGRATION, "golden_pages.txt")));
const goldenAliases = readLines(join(MIGRATION, "golden_aliases.txt")).map(
  (line) => line.split("\t"),
);
const goldenFiles = new Set(readLines(join(MIGRATION, "golden_files.txt")));

// Enumerate the Hugo build the same way the golden set was extracted from _site.
const hugoPages = new Set();
const hugoFiles = new Set();
for (const path of walk(PUBLIC).sort(compareBytes)) {
  const rel = relative(PUBLIC, path);
  hugoFiles.add(rel);
  if (/\.(html|xml|json)$/.test(rel) && !rel.endsWith("index.html")) {
    hugoPages.add(`/${rel}`);
  }
}
for (const path of walk(PUBLIC).sort(compareBytes)) {
  const rel = relative(PUBLIC, path);
  if (rel === "index.html" || rel.endsWith("/index.html")) {
    hugoPages.add(`/${rel.replace(/index\.html$/, "")}`);
  }
}

const missingPages = [...goldenPages].filter((p) => !hugoPages.has(p));
const extraPages = [...hugoPages].filter((p) => !goldenPages.has(p));

const aliasUrls = new Set(goldenAliases.map(([from]) => from));
const missingAliases = [...aliasUrls].filter((u) => !hugoPages.has(u));

// Files: golden was the Jekyll _site inventory. Some plugin artifacts are
// consciously not reproduced (documented in the migration report).
const skipFiles = [/^https:/]; // broken jekyll-feed artifact (garbage on live site)
const skipped = new Set();
for (const pattern of skipFiles) {
  for (const file of goldenFiles) if (pattern.test(file)) skipped.add(file);
}
const missingFiles = [...goldenFiles].filter(
  (f) => !hugoFiles.has(f) && !skipped.has(f),
);
const extraFiles = [...hugoFiles].filter((f) => !goldenFiles.has(f));

const show = (label, values, render) => {
  console.log(`${label} (${values.length}):`);
  for (const value of values.sort(compareBytes).slice(0, 30)) {
    console.log(`  ${render(value)}`);
  }
};

console.log("== pages ==");
console.log(`golden: ${goldenPages.size}  hugo: ${hugoPages.size}`);
show("MISSING in Hugo", missingPages, (u) => u);
show("EXTRA in Hugo", extraPages, (u) => u);

console.log("== aliases ==");
console.log(`golden: ${aliasUrls.size}  missing: ${missingAliases.length}`);
for (const url of missingAliases.sort(compareBytes).slice(0, 30)) {
  console.log(`  MISSING ${url}`);
}

console.log("== files ==");
console.log(`golden: ${goldenFiles.size}  hugo: ${hugoFiles.size}`);
show("MISSING in Hugo", missingFiles, (f) => f);
show("EXTRA in Hugo", extraFiles, (f) => f);

process.exit(
  missingPages.length === 0 && missingAliases.length === 0 && missingFiles.length === 0
    ? 0
    : 1,
);
