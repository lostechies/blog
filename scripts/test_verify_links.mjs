#!/usr/bin/env node

// Unit tests for the link-resolution rules in scripts/verify_links.mjs. Kept
// separate so the production verifier stays a single-purpose script.
//
// Usage: node scripts/test_verify_links.mjs

import { classify, resolvable } from "./verify_links.mjs";

let failed = false;

function assertEqual(expected, actual, label) {
  const same =
    expected instanceof Array && actual instanceof Array
      ? expected.length === actual.length &&
        expected.every((value, i) => value === actual[i])
      : expected === actual;
  if (same) return;

  console.error(
    `FAIL ${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`,
  );
  failed = true;
}

function assert(condition, label) {
  assertEqual(true, condition, label);
}

const files = new Set([
  "index.html",
  "about.html",
  "jimmybogard/archive.html",
  "jimmybogard/2017/01/26/new-year-new-blog/index.html",
  "blogs/chad_myers/index.html",
]);

assert(resolvable(files, "/"), "/ resolves to index.html");
assert(resolvable(files, "/about"), "/about resolves to about.html");
assertEqual(false, resolvable(files, "/about/"), "/about/ does not resolve to about.html");
assert(resolvable(files, "/jimmybogard/archive"), "/archive resolves to archive.html");
assertEqual(
  false,
  resolvable(files, "/jimmybogard/archive/"),
  "/archive/ does not resolve to archive.html",
);
assert(
  resolvable(files, "/jimmybogard/2017/01/26/new-year-new-blog"),
  "extensionless post resolves to index.html",
);
assert(
  resolvable(files, "/jimmybogard/2017/01/26/new-year-new-blog/"),
  "trailing-slash post resolves to index.html",
);
assert(resolvable(files, "/blogs/chad%5Fmyers/"), "percent-encoded directory resolves");
assertEqual(
  false,
  resolvable(files, "/blogs/joe_ocampo/default.aspx"),
  "missing target stays broken",
);

assertEqual(
  ["internal", "/about"],
  classify("https://lostechies.com/about#top"),
  "apex host is internal",
);
assertEqual(
  ["internal", "/about"],
  classify("https://www.lostechies.com/about"),
  "www host is internal",
);
assertEqual(
  ["external", "//static.techpines.com/rainbow.css"],
  classify("//static.techpines.com/rainbow.css"),
  "protocol-relative external is external",
);
assertEqual(["skip", null], classify("mailto:[EMAIL]"), "mailto is skipped");
assertEqual(["skip", null], classify("#section"), "fragment is skipped");

if (failed) {
  process.exit(1);
} else {
  console.log("verify_links tests: OK");
}
