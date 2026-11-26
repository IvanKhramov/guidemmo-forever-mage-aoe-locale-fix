#!/usr/bin/env bash
# Checks the latest CurseForge release of the original addon against this add-on.
#
# Prints a Markdown report to stdout and writes key=value pairs to $GITHUB_OUTPUT
# (if set): file_id, is_new (latest file differs from upstream-file-id), ok (all zones covered).
# Exit code is non-zero only when the check itself fails (network, unexpected format).
set -euo pipefail

MOD_SLUG="guidemmo-forever-mage-aoe"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LOCALE_FILE="$ROOT/GuidemmosMageAOEGuide_LocaleFix/MapLocale.lua"
KNOWN_ID="$(tr -d '[:space:]' < "$ROOT/upstream-file-id")"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

curl -fsSL "https://api.cfwidget.com/wow/addons/$MOD_SLUG" -o "$WORK/meta.json"
FILE_ID="$(jq -r '.download.id' "$WORK/meta.json")"
FILE_NAME="$(jq -r '.download.name' "$WORK/meta.json")"
UPLOADED="$(jq -r '.download.uploaded_at' "$WORK/meta.json")"
[[ "$FILE_ID" =~ ^[0-9]+$ ]] || { echo "unexpected file id: $FILE_ID" >&2; exit 1; }

# CurseForge CDN layout: files/<id / 1000>/<id % 1000 without leading zeros>/<name>
curl -fsSL "https://mediafilez.forgecdn.net/files/$((FILE_ID / 1000))/$((FILE_ID % 1000))/$FILE_NAME" -o "$WORK/orig.zip"
unzip -q "$WORK/orig.zip" -d "$WORK/src"
DATA="$(find "$WORK/src" -name Data.lua | head -1)"
MAIN="$(find "$WORK/src" -name GuidemmosMageAOEGuide.lua | head -1)"
TOC="$(find "$WORK/src" -name GuidemmosMageAOEGuide.toc | head -1)"
[[ -n "$DATA" && -n "$MAIN" && -n "$TOC" ]] || { echo "Data.lua, GuidemmosMageAOEGuide.lua or .toc not found in $FILE_NAME" >&2; exit 1; }

VERSION="$(sed -n 's/^## Version: *//p' "$TOC" | tr -d '\r')"
INTERFACE="$(sed -n 's/^## Interface: *//p' "$TOC" | tr -d '\r')"

# The plugin relies on: the global data table, spot.zone as name or list, lookup by names[1].
problems=()
grep -q '^GuidemmosMageAOEData *=' "$DATA" || problems+=("global \`GuidemmosMageAOEData\` not found in Data.lua")
grep -q 'spot\.zone' "$MAIN" || problems+=("\`spot.zone\` no longer used in GuidemmosMageAOEGuide.lua")

# First zone name of every spot (the one the guide uses as the lookup key).
grep -oE 'zone *= *(\{ *)?"[^"]+"' "$DATA" | sed -E 's/.*"([^"]+)"/\1/' | sort -u > "$WORK/zones"
grep -oE '^\s*\["[^"]+"\] *= *[0-9]+' "$LOCALE_FILE" | sed -E 's/.*\["([^"]+)"\].*/\1/' | sort -u > "$WORK/known"
[[ -s "$WORK/zones" ]] || problems+=("no zones found in Data.lua")
mapfile -t missing < <(comm -23 "$WORK/zones" "$WORK/known")
for z in "${missing[@]}"; do problems+=("zone \`$z\` is missing from MapLocale.lua"); done

ok=true; ((${#problems[@]})) && ok=false
is_new=true; [[ "$FILE_ID" == "$KNOWN_ID" ]] && is_new=false

echo "Original: version **${VERSION:-?}**, interface \`$INTERFACE\`, file [$FILE_ID](https://www.curseforge.com/wow/addons/$MOD_SLUG/files/$FILE_ID), uploaded $UPLOADED."
echo "Last checked file: $KNOWN_ID. Zones in Data.lua: $(wc -l < "$WORK/zones")."
echo
if $ok; then
    echo "All zones are covered and the data format looks unchanged."
else
    echo "Problems:"
    printf -- '- %s\n' "${problems[@]}"
fi

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    { echo "file_id=$FILE_ID"; echo "version=${VERSION:-?}"; echo "is_new=$is_new"; echo "ok=$ok"; } >> "$GITHUB_OUTPUT"
fi
