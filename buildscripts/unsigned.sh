#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

"$SCRIPT_DIR"/buildscripts/clean.sh
wsl "$SCRIPT_DIR"/buildscripts/clean.sh
"$SCRIPT_DIR"/buildscripts/build.sh
wsl make