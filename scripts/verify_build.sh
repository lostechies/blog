#!/usr/bin/env bash
# Post-build sanity checks for the Hugo output. Catches template artifacts that
# rendered-HTML content diffs miss: unrendered Liquid/Go-template syntax, Hugo's
# "<no value>" placeholder, and JavaScript that does not parse.
#
# Usage: scripts/verify_build.sh [public-dir]   (default: public)

set -euo pipefail

PUBLIC="${1:-public}"
status=0

if [ ! -d "$PUBLIC" ]; then
  echo "error: build directory '$PUBLIC' not found" >&2
  exit 1
fi

echo "==> Checking for Hugo '<no value>' placeholders"
if grep -rl --include='*.html' --include='*.js' --include='*.json' --include='*.xml' '<no value>' "$PUBLIC"; then
  echo "error: '<no value>' found in build output" >&2
  status=1
fi

echo "==> Checking for unrendered template syntax in JS/JSON/XML"
if grep -rlE --include='*.js' --include='*.json' --include='*.xml' '\{\{|\{%' "$PUBLIC"; then
  echo "error: unrendered Liquid/Go-template syntax found in build output" >&2
  status=1
fi

echo "==> Checking for unrendered gist tags in HTML"
if grep -rl --include='*.html' '{% gist' "$PUBLIC"; then
  echo "error: unconverted {% gist %} tag found in build output" >&2
  status=1
fi

echo "==> Syntax-checking JavaScript"
while IFS= read -r -d '' file; do
  if ! node --check "$file"; then
    status=1
  fi
done < <(find "$PUBLIC/assets/js" -name '*.js' -print0)

echo "==> Validating JSON endpoints"
while IFS= read -r -d '' file; do
  if ! node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$file"; then
    echo "error: invalid JSON: $file" >&2
    status=1
  fi
done < <(find "$PUBLIC" -name '*.json' -not -name 'package*.json' -print0)

if [ "$status" -eq 0 ]; then
  echo "OK: build output passed all checks"
fi
exit "$status"
