#! /usr/bin/env sh

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

find I2P -type d -exec chmod -v 755 {} \;
find I2P -type f -exec chmod -v +rw {} \;
find I2P -type d -exec chmod -v 755 {} \;
find I2P -type f -exec chmod -v +rw {} \;