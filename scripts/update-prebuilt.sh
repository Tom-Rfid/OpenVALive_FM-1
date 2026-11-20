#!/usr/bin/env bash
# OpenVALive - copies the files of a CI build (a GitHub release) into prebuilt/,
# so the repository itself carries ready-to-use binaries.
#
#   bash scripts/update-prebuilt.sh [TAG] [OWNER/REPO]
#     TAG         nightly (default), preview-<branch>, or a release such as v0.1.0
#     OWNER/REPO  default: Tom-Rfid/OpenVALive_FM-1
#
# Needs curl, unzip and python3 (or the gh CLI). Then review and commit prebuilt/.
set -euo pipefail

TAG="${1:-nightly}"
REPO="${2:-Tom-Rfid/OpenVALive_FM-1}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/prebuilt"
URL="https://github.com/$REPO/releases/download/$TAG"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# the release's asset names, from the GitHub API
if command -v gh >/dev/null 2>&1; then
    NAMES=$(gh api "repos/$REPO/releases/tags/$TAG" --jq '.assets[].name')
else
    NAMES=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/tags/$TAG" \
            | python3 -c 'import json,sys; print("\n".join(a["name"] for a in json.load(sys.stdin)["assets"]))')
fi

for name in $NAMES; do
    echo "download $name"
    curl -fsSL -o "$TMP/$name" "$URL/$name"
done

mkdir -p "$OUT/fm1" "$OUT/web"
rm -f "$OUT"/fm1/*.fwsc "$OUT"/fm1/*.zip
cp "$TMP"/openvalive-fm1-[0-9]*.fwsc "$TMP/firmware.json" "$TMP/fm1_install.py" "$TMP/fm1ports.py" \
   "$TMP/flash.ps1" "$TMP/FLASH-FM1.bat" "$OUT/fm1/"
cp "$TMP"/OpenVALive-FM1-*.zip "$OUT/fm1/" 2>/dev/null || true
rm -rf "$OUT/web" && mkdir -p "$OUT/web"
unzip -q "$TMP"/openvalive-fm1-site-*.zip -d "$OUT/web"

echo "$TAG" > "$OUT/SOURCE_TAG"
echo
echo "prebuilt/ updated from $REPO release $TAG:"
find "$OUT" -maxdepth 2 -type f | sed "s|$ROOT/||" | sort | head -40
