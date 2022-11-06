#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi
./clean.sh
wsl make distclean
./build.sh
cd "$SCRIPT_DIR/I2P" || exit 1

TORSOCKS=$(which torsocks)
if [ -f "${TORSOCKS}" ]; then
    . "${TORSOCKS}" on
fi
#./torbrowser-windows.sh
../src/win/torbrowser-windows.sh
version="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/downloads.json | jq -r ".version")"
. "${TORSOCKS}" off
locale="en-US" # mention your locale. default = en-US
if [ -d /etc/default/locale ]; then
    . /etc/default/locale
    locale=$(echo "${LANG}" | cut -d . -f1)
fi
rm -vrf "tor-browser_${locale}"
cd "$SCRIPT_DIR" || exit 1

rm -rf I2P-portable && cp -r I2P I2P-portable
#powershell Compress-Archive -force I2P-portable I2P-portable.zip
zip -r I2P-portable.zip I2P-portable