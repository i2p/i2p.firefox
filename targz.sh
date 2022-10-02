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
./lib/torbrowser.sh <- haha just kidding, but uncomment this to make it pack everything it needs into the tar.gz
version="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/downloads.json | jq -r ".version")"
locale="en-US" # mention your locale. default = en-US
if [ -d /etc/default/locale ]; then
    . /etc/default/locale
    locale=$(echo "${LANG}" | cut -d . -f1)
fi
rm -vrf "tor-browser-linux64-${version}_${locale}"
cd "$SCRIPT_DIR" || exit 1




tar czvf I2P.tar.gz I2P
