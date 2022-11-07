#! /usr/bin/env bash
set -e 

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f config_overide.sh ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

. "$HOME/github-release-config.sh"

if [ -z $TODAYSDATE ]; then
  TODAYSDATE=$(date -d '-1 day' '+%Y%m%d')
fi

echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
unzip I2P.zip
sleep 1
find I2P -type d -exec chmod 755 {} \;
find I2P -type f -exec chmod +rw {} \;