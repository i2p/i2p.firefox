#! /usr/bin/env sh

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
echo "$SCRIPT_DIR"
cd "$SCRIPT_DIR" || exit 1

echo "fixing permissions"

find "$SCRIPT_DIR/I2P" -type d -exec sudo chmod -v 755 {} \;
find "$SCRIPT_DIR/I2P" -type f -exec sudo chmod -v +rw {} \;
find "$SCRIPT_DIR/I2P" -type d -exec sudo chmod -v 755 {} \;
find "$SCRIPT_DIR/I2P" -type f -exec sudo chmod -v +rw {} \;