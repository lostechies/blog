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

- 4,716 internal link targets checked across the Hugo build.
- 0 regressions: nothing that resolves on the live Jekyll site is broken by Hugo.
- 494 targets are broken — all pre-existing (broken identically on the live site):
  extensionless nav links (`/about`, `/<author>/archive`, `/<author>/tags`), old
  absolute URLs to long-gone dasBlog/WordPress pages, and a few protocol-relative
  external links.

## Date handling

Jekyll rendered permalink date tokens in the **build machine's local timezone**;
GitHub Pages builds in UTC. The golden reference was therefore rebuilt with
`TZ=UTC`. Hugo renders date tokens in the front matter's explicit offset (`+00:00`
site-wide, verified uniform), which is deterministic across build machines and
matches production.
