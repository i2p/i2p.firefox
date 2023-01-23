#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi
export machine=unix
"$SCRIPT_DIR"/buildscripts/clean.sh
wsl "$SCRIPT_DIR"/buildscripts/clean.sh
"$SCRIPT_DIR"/buildscripts/build.sh
cd "$SCRIPT_DIR/I2P" || exit 1

TORSOCKS=$(which torsocks)
if [ -f "${TORSOCKS}" ]; then
    . "${TORSOCKS}" on
fi
"$SCRIPT_DIR"/src/unix/torbrowser.sh
version="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/downloads.json | jq -r ".version")"
. "${TORSOCKS}" off
locale="en-US" # mention your locale. default = en-US
if [ -d /etc/default/locale ]; then
    . /etc/default/locale
    locale=$(echo "${LANG}" | cut -d . -f1)
fi
rm -vrf "tor-browser_${locale}"
cd "$SCRIPT_DIR" || exit 1

tar czvf I2P.tar.gz I2P
