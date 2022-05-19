#! /usr/bin/env sh

### How to set up this script:
#
# This script will not work unless you give it a Github API key.
# You need to create a file in your $HOME directory, which on
# Windows will by /c/Users/yourusername, called github-release-config.sh,
# containing this key as the variable GITHUB_TOKEN.
# github-release-config must also contain:
# GITHUB_USERNAME=your github username
./unsigned.sh

. "$HOME/github-release-config.sh"

. ./i2pversion

if [ -f ./i2pversion_override ]; then
  . ./i2pversion_override
fi

TODAYSDATE=$(date +%Y%M%d)

if [ -z "$DESCRIPTION" ]; then
  DESCRIPTION="Daily unsigned build of i2p.firefox for $TODAYSDATE"
fi

echo github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
github-release release -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
EXECHECKSUM=$(sha256sum "I2P-Profile-Installer-$I2P_VERSION.exe")
echo github-release upload -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P-Profile-Installer-$I2P_VERSION.exe" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P-Profile-Installer-$I2P_VERSION.exe"
github-release upload -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "I2P-Profile-Installer-$I2P_VERSION.exe" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P-Profile-Installer-$I2P_VERSION.exe"
cd build || exit
tar -a -cf ../I2P.zip I2P
ZIPCHECKSUM=$(sha256sum "../I2P.zip")
echo github-release upload -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../I2P.zip" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P.zip"
github-release upload -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "../I2P.zip" -l "$EXECHECKSUM" -t "$TODAYSDATE" -n "I2P.zip"