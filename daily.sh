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
./unsigned.sh

. "$HOME/github-release-config.sh"

if [ -f ./i2pversion_override ]; then
  . ./i2pversion_override
fi

TODAYSDATE=$(date +%Y%m%d)

if [ -z "$DESCRIPTION" ]; then
  DESCRIPTION="Daily unsigned build of i2p.firefox for $TODAYSDATE"
fi

echo github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
EXECHECKSUM=$(sha256sum "I2P-Profile-Installer-$I2P_VERSION.exe")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P-Profile-Installer-$I2P_VERSION.exe" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P-Profile-Installer-$I2P_VERSION.exe"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P-Profile-Installer-$I2P_VERSION.exe" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P-Profile-Installer-$I2P_VERSION.exe"
cd build || exit
powershell Compress-Archive I2P I2P-jpackage-windows-$(I2P_VERSION).zip || zip I2P-jpackage-windows-$(I2P_VERSION).zip -r I2P
ZIPCHECKSUM=$(sha256sum "../I2P.zip")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../I2P.zip" -l "$ZIPCHECKSUM" -t "$TODAYSDATE" -n "I2P.zip"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../I2P.zip" -l "$ZIPCHECKSUM" -t "$TODAYSDATE" -n "I2P.zip"

TARCHECKSUM=$(sha256sum "../../i2p.i2p.jpackage-build.tar.gz")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../../i2p.i2p.jpackage-build.tar.gz" -l "Upstream I2P Router source code $TARCHECKSUM" -t "$TODAYSDATE" -n "i2p.i2p.jpackage-build.tar.gz"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../../i2p.i2p.jpackage-build.tar.gz" -l "Upstream I2P Router source code $TARCHECKSUM" -t "$TODAYSDATE" -n "i2p.i2p.jpackage-build.tar.gz"
