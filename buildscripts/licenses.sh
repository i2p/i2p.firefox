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

mkdir -p "$SCRIPT_DIR"/buildlicenses
	cp license/* "$SCRIPT_DIR"/buildlicenses
	cp LICENSE.md "$SCRIPT_DIR"/buildlicenses/MIT.txt
	cat "$SCRIPT_DIR"/buildlicenses/LICENSE.index \
		"$SCRIPT_DIR"/buildlicenses/EPL.txt \
		"$SCRIPT_DIR"/buildlicenses/GPL+CLASSPATH.txt \
		"$SCRIPT_DIR"/buildlicenses/HTTPS-Everywhere.txt \
		"$SCRIPT_DIR"/buildlicenses/LICENSE.tor \
		"$SCRIPT_DIR"/buildlicenses/MIT.txt \
		"$SCRIPT_DIR"/buildlicenses/MPL2.txt \
		"$SCRIPT_DIR"/buildlicenses/NoScript.txt \
		"$SCRIPT_DIR"/buildlicenses/NSS.txt \
		"$SCRIPT_DIR"/buildlicenses/I2P.txt > "$SCRIPT_DIR"/buildlicenses/LICENSE.txt
	unix2dos "$SCRIPT_DIR"/buildlicenses/LICENSE.txt