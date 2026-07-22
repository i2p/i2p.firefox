#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)

usage() {
    cat <<'EOF'
Usage: buildscripts/update-version.sh VERSION AUTHOR

Update the release version in i2pversion and docs/RELEASE.md, and prepend a
version entry to changelog.txt.

Example:
  buildscripts/update-version.sh *.**.* "Author Name"
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

if [[ $# -ne 2 ]]; then
    usage >&2
    exit 2
fi

VERSION=$1
AUTHOR=$2

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: VERSION must use MAJOR.MINOR.PATCH format: $VERSION" >&2
    exit 2
fi

if [[ -z "$AUTHOR" || "$AUTHOR" == *$'\n'* || "$AUTHOR" == *$'\r'* ]]; then
    echo "ERROR: AUTHOR must be non-empty and must not contain line breaks" >&2
    exit 2
fi

CHANGELOG="$REPO_ROOT/changelog.txt"
VERSION_FILE="$REPO_ROOT/i2pversion"
RELEASE_NOTES="$REPO_ROOT/docs/RELEASE.md"

for file in "$CHANGELOG" "$VERSION_FILE" "$RELEASE_NOTES"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: required file not found: $file" >&2
        exit 1
    fi
done

RELEASE_DATE=${RELEASE_DATE:-$(date -u +%F)}
if [[ ! "$RELEASE_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "ERROR: RELEASE_DATE must use YYYY-MM-DD format: $RELEASE_DATE" >&2
    exit 2
fi

if ! grep -Eq '^# I2P Easy-Install [0-9]+\.[0-9]+\.[0-9]+$' "$RELEASE_NOTES"; then
    echo "ERROR: could not find the release title in $RELEASE_NOTES" >&2
    exit 1
fi

if ! grep -Eq '^This release updates the embedded I2P router to I2P [0-9]+\.[0-9]+\.[0-9]+\.$' "$RELEASE_NOTES"; then
    echo "ERROR: could not find the release summary in $RELEASE_NOTES" >&2
    exit 1
fi

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/i2p-version.XXXXXX")
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Update only the numeric fallback values. The tag-derived assignments must
# remain untouched because tagged builds derive their version from GITHUB_TAG.
awk -v version="$VERSION" '
    /^[[:space:]]*I2PFIREFOX_VERSION="[0-9]+\.[0-9]+\.[0-9]+"/ ||
    /^[[:space:]]*export I2PFIREFOX_VERSION="[0-9]+\.[0-9]+\.[0-9]+"/ {
        sub(/"[0-9]+\.[0-9]+\.[0-9]+"/, "\"" version "\"")
    }
    { print }
' "$VERSION_FILE" > "$TEMP_DIR/i2pversion"

{
    printf '%s %s\n' "$RELEASE_DATE" "$AUTHOR"
    printf ' * Version %s\n\n' "$VERSION"
    cat "$CHANGELOG"
} > "$TEMP_DIR/changelog.txt"

awk -v version="$VERSION" '
    NR == 1 {
        sub(/[0-9]+\.[0-9]+\.[0-9]+$/, version)
    }
    /^This release updates the embedded I2P router to I2P [0-9]+\.[0-9]+\.[0-9]+\.$/ {
        sub(/[0-9]+\.[0-9]+\.[0-9]+\./, version ".")
    }
    { print }
' "$RELEASE_NOTES" > "$TEMP_DIR/RELEASE.md"

mv "$TEMP_DIR/i2pversion" "$VERSION_FILE"
mv "$TEMP_DIR/changelog.txt" "$CHANGELOG"
mv "$TEMP_DIR/RELEASE.md" "$RELEASE_NOTES"

echo "Updated version to $VERSION"
echo "Release author: $AUTHOR"
echo "Release date: $RELEASE_DATE"
