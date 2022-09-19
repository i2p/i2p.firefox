#! /usr/bin/env bash

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

### How to set up this script:
#
# This script will not work unless you give it a Github API key.
# You need to create a file in your $HOME directory, which on
# Windows will by /c/Users/yourusername, called github-release-config.sh,
# containing this key as the variable GITHUB_TOKEN.
# github-release-config.sh must also contain:
# GITHUB_USERNAME=your github username
git clean -fd
git checkout .
./targz.sh

. "$HOME/github-release-config.sh"

if [ -f ./i2pversion_override ]; then
  . ./i2pversion_override
fi

TODAYSDATE=$(date +%Y%m%d)

if [ -z "$DESCRIPTION" ]; then
  DESCRIPTION="Daily unsigned build of i2p.firefox for $TODAYSDATE\n"
  DESCRIPTION+="===================================================\n"
  DESCRIPTION+="\n"
  DESCRIPTION+="These builds are automatically built on a daily basis and may have serious bugs.\n"
  DESCRIPTION+="They are intended for testing purposes only, use them at your own risk.\n"
  DESCRIPTION+="\n"
fi

echo github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
sleep 2s
ZIPCHECKSUM=$(sha256sum "I2P.tar.gz")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P.tar.gz" -l "$ZIPCHECKSUM" -t "$TODAYSDATE" -n "I2P.tar.gz"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P.tar.gz" -l "$ZIPCHECKSUM" -t "$TODAYSDATE" -n "I2P.tar.gz"
