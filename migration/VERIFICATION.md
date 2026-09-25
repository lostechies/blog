# Migration Verification Summary — Jekyll → Hugo

Generated during the Phase 5 verification gate. Builds compared:
golden reference = Jekyll built with `TZ=UTC` (matches GitHub Pages production),
candidate = Hugo (`hugo --cleanDestinationDir`).

## URL contract — PASS

| Check | Golden | Hugo | Missing | Extra |
|---|---|---|---|---|
| Canonical pages | 4,937 | 4,937 | 0 | 0 |
| Old-URL aliases (dasBlog/WordPress era) | 1,916 | 1,916 | 0 | — |
| Files (pages, media, assets) | 9,742 | 9,742 | 0 | 0 |

Every canonical URL from the live site resolves in the Hugo build at the identical
path, and every one of the 1,916 historical alias URLs (e.g.
`/blogs/jimmy_bogard/archive/2007/04/12/….aspx/`) resolves via a Hugo alias page.

Conscious deltas (documented decisions):
- `/redirects.json` — jekyll-redirect-from plugin artifact, nothing consumes it; not reproduced.

## Content — PASS with documented renderer differences

Full rendered-text comparison of all 2,844 posts (whitespace-insensitive outside
`<pre>`, entity-normalized):

- 2,180 posts: identical text
- 664 posts: differ; all inspected differences fall into these families:
  1. **Live-site artifacts Hugo fixes** (majority): kramdown rendered stray/broken
     HTML as visible text — literal `</p>`, `</ul>`, `</link>`, `</pre>` strings,
     visible `\*` escapes, uppercase `<PRE>` mishandling — all currently visible on
     the live site; Hugo renders them correctly.
  2. **List-marker handling**: kramdown consumed hand-typed "2." "3." lines as
     ordered-list markers; CommonMark keeps them as text (minor visual change in a
     subset of old posts).
  3. **Invisible deltas**: heading-id entity bytes (`id="don8217t…"`), rouge inline-code
     classes, raw-HTML attribute whitespace.
- Code blocks: verified separately — after the raw-HTML blank-line fix (below),
  all code content matches except 62 posts whose sources contain malformed HTML
  (nested literal `</pre>`, uppercase `<PRE>`); in every inspected case Hugo's
  output is equal or closer to author intent than the live site.

Source-level fix applied during migration: blank lines inside raw HTML blocks
(`<table>`, `<div>`, `<ul>`, …) are collapsed because CommonMark would otherwise
split the block and render the remainder as indented code (42+ posts affected;
whitespace inside these elements is insignificant, so rendering is unchanged).

## Internal links — PASS, zero regressions

- 4,709 internal link targets checked across the Hugo build.
- 0 regressions: nothing that resolves on the live Jekyll site is broken by Hugo.
- 398 targets are broken — all pre-existing (broken identically on the live site),
  almost entirely old absolute URLs to long-gone dasBlog/WordPress pages. The
  remaining links are stale paths from the same era rather than migration damage.
- The checker applies GitHub Pages' resolution rules: `/foo` resolves to
  `foo.html` or `foo/index.html`, while `/foo/` resolves only to `foo/index.html`.
  This is why the earlier report incorrectly counted `/about` and every
  `/<author>/archive` and `/<author>/tags` link as broken. Percent-encoded paths
  are decoded before lookup, and protocol-relative external links are excluded.
- Of the 86 targets the earlier report wrongly marked broken, 61 have populated
  main content (including `/about` and `/jimmybogard/archive`); 25 are headless
  pages such as most `/<author>/tags` pages. For example, `/jimmybogard/tags`
  returns 200 with an empty main area on the live Jekyll site, and the Hugo build
  reproduces that same empty page. Link verification checks resolution, not
  whether a page happens to have content.
- The 9 skipped protocol-relative external targets are off-site resources, not
  internal pages.

## Build-output checks — `scripts/verify_build.sh`

The content diff above only compares rendered post HTML, which missed three
regressions in the first pass of this migration: Liquid tags left in
`static/assets/js/*.js` (a JS syntax error that broke the home page loader),
Hugo's `<no value>` placeholder in the templated `collections.js`, and one
`{% gist %}` tag that the migration script failed to convert. `scripts/verify_build.sh`
now runs in the PR build workflow (`.github/workflows/build.yaml`) and fails on:

- `<no value>` anywhere in the output
- unrendered `{{`/`{%` in JS/JSON/XML
- unconverted `{% gist` in HTML
- JavaScript under `assets/js/` that fails `node --check`
- JSON endpoints that fail to parse

Run locally with `hugo && scripts/verify_build.sh public`.

## Date handling

Jekyll rendered permalink date tokens in the **build machine's local timezone**;
GitHub Pages builds in UTC. The golden reference was therefore rebuilt with
`TZ=UTC`. Hugo renders date tokens in the front matter's explicit offset (`+00:00`
site-wide, verified uniform), which is deterministic across build machines and
matches production.
