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

cp "$SCRIPT_DIR"/src/nsis/*.nsi "$SCRIPT_DIR"/build
cp "$SCRIPT_DIR"/src/nsis/*.nsh "$SCRIPT_DIR"/build
cp "$SCRIPT_DIR"/src/icons/*.ico "$SCRIPT_DIR"/build
cd "$SCRIPT_DIR"/build && makensis i2pbrowser-installer.nsi && cp I2P-Easy-Install-Bundle-*.exe ../ && echo "built windows installer"