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

mkdir -p "$SCRIPT_DIR"/build/licenses
	cp license/* "$SCRIPT_DIR"/build/licenses
	cp LICENSE.md "$SCRIPT_DIR"/build/licenses/MIT.txt
	cat "$SCRIPT_DIR"/build/licenses/LICENSE.index \
		"$SCRIPT_DIR"/build/licenses/EPL.txt \
		"$SCRIPT_DIR"/build/licenses/GPL+CLASSPATH.txt \
		"$SCRIPT_DIR"/build/licenses/HTTPS-Everywhere.txt \
		"$SCRIPT_DIR"/build/licenses/LICENSE.tor \
		"$SCRIPT_DIR"/build/licenses/MIT.txt \
		"$SCRIPT_DIR"/build/licenses/MPL2.txt \
		"$SCRIPT_DIR"/build/licenses/NoScript.txt \
		"$SCRIPT_DIR"/build/licenses/NSS.txt \
		"$SCRIPT_DIR"/build/licenses/I2P.txt > "$SCRIPT_DIR"/build/licenses/LICENSE.txt
	unix2dos "$SCRIPT_DIR"/build/licenses/LICENSE.txt