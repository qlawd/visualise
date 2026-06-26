#!/usr/bin/env bash
# shoot.sh — render an HTML file to a PNG with a headless Chromium-family browser.
# Used by the /visualise self-critique loop so the agent can *see* what it built.
#
# Usage:   scripts/shoot.sh <input.html> [output.png]
# Output:  prints the absolute PNG path on success.
# Exit:    0 = screenshot written · 3 = no headless browser found (caller should
#          skip the visual pass and just open the file).
#
# Override the browser with:  CHROME=/path/to/browser scripts/shoot.sh ...
set -euo pipefail

in="${1:?usage: shoot.sh <input.html> [output.png]}"
[ -f "$in" ] || { echo "shoot.sh: no such file: $in" >&2; exit 1; }

# Resolve an absolute path for the file:// URL (portable; no realpath dependency).
case "$in" in
  /*) abs="$in" ;;
  *)  abs="$(cd "$(dirname "$in")" && pwd)/$(basename "$in")" ;;
esac

out="${2:-/tmp/visualise-shot-$(basename "${in%.*}").png}"

# Find a Chromium-family browser across macOS / Linux / common installs.
find_browser() {
  if [ -n "${CHROME:-}" ] && [ -x "${CHROME}" ]; then echo "$CHROME"; return 0; fi
  local c
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
    google-chrome-stable google-chrome chromium chromium-browser \
    microsoft-edge brave-browser chrome-headless-shell; do
    if [ -x "$c" ]; then echo "$c"; return 0; fi
    if command -v "$c" >/dev/null 2>&1; then command -v "$c"; return 0; fi
  done
  return 1
}

browser="$(find_browser)" || { echo "shoot.sh: no headless browser found" >&2; exit 3; }

# --virtual-time-budget lets animations/data settle before the frame is grabbed.
"$browser" \
  --headless --disable-gpu --no-sandbox --hide-scrollbars \
  --window-size="${VIS_W:-1440},${VIS_H:-900}" \
  --force-device-scale-factor=1 \
  --virtual-time-budget="${VIS_SETTLE:-3500}" \
  --screenshot="$out" \
  "file://$abs" >/dev/null 2>&1

[ -s "$out" ] || { echo "shoot.sh: screenshot failed (empty file)" >&2; exit 1; }
echo "$out"
