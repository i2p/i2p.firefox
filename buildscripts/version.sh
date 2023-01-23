#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

echo "!define VERSIONMAJOR $VERSIONMAJOR" > "$SCRIPT_DIR"/src/nsis/i2pbrowser-version.nsi
echo "!define VERSIONMINOR $VERSIONMINOR" >> "$SCRIPT_DIR"/src/nsis/i2pbrowser-version.nsi
echo "!define VERSIONBUILD $VERSIONBUILD" >> "$SCRIPT_DIR"/src/nsis/i2pbrowser-version.nsi
echo "!define I2P_VERSION $PROFILE_VERSION" > "$SCRIPT_DIR"src/nsis/i2pbrowser-jpackage.nsi

echo "$PROFILE_VERSION" > "$SCRIPT_DIR"/build/version.txt
echo "$PROFILE_VERSION" > "$SCRIPT_DIR"/build/version.txt
sed 's|!define VERSION||g' src/nsis/i2pbrowser-version.nsi | sed 's| |=|g' > .version
