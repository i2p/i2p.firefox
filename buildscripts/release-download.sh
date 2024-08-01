#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

mv "$SCRIPT_DIR/config_override.sh" "$SCRIPT_DIR/config_override.sh.bak"
. "$SCRIPT_DIR/config.sh"

### How to set up this script:
#
# This script will not work unless you give it a Github API key.
# You need to create a file in your $HOME directory, which on
# Windows will by /c/Users/yourusername, called github-release-config.sh,
# containing this key as the variable GITHUB_TOKEN.
# github-release-config.sh must also contain:
# GITHUB_USERNAME=your github username

. "$HOME/github-release-config.sh"

if [ -f ./i2pversion_override ]; then
  . ./i2pversion_override
fi



echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P-Easy-Install-Bundle-$I2P_VERSION.exe" -t "i2p-firefox-$I2P_VERSION"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P-Easy-Install-Bundle-$I2P_VERSION.exe" -t "i2p-firefox-$I2P_VERSION"

echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$I2P_VERSION"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$I2P_VERSION"

echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2p.i2p.jpackage-build.tar.gz" -t "$I2P_VERSION"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2p.i2p.jpackage-build.tar.gz" -t "$I2P_VERSION"

echo github-release download -u "$GITHUB_USERNAME" -r i2p -t "$I2P_VERSION" -n "./I2P-jpackage-windows-$I2P_VERSION.zip"
github-release download -u "$GITHUB_USERNAME" -r i2p -t "$I2P_VERSION" -n "./I2P-jpackage-windows-$I2P_VERSION.zip"
