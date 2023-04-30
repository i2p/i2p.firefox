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

echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2pwinupdate.su3" -t "$I2P_VERSION"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2pwinupdate.su3" -t "$I2P_VERSION"

echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2pwinupdate.su3.torrent" -t "$I2P_VERSION"
github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "i2pwinupdate.su3.torrent" -t "$I2P_VERSION"

if [ ! -z "$I2P_SNARK_DIR" ]; then
    if [ "$I2P_SNARK_DIR" = "$HOME/.i2p/i2psnark" ]; then
        cp -v "i2pwinupdate.su3" "$I2P_SNARK_DIR"
        cp -v "i2pwinupdate.su3.torrent" "$I2P_SNARK_DIR"
    fi
    if [ "$I2P_SNARK_DIR" = "$LOCALAPPDATA/i2p/i2psnark/" ]; then
        cp -v "i2pwinupdate.su3" "$I2P_SNARK_DIR"
        cp -v "i2pwinupdate.su3.torrent" "$I2P_SNARK_DIR"
    fi
    if [ "$I2P_SNARK_DIR" = "/var/lib/i2p/i2p-config/i2psnark/" ]; then
        sudo cp -v "i2pwinupdate.su3" "$I2P_SNARK_DIR"
        sudo cp -v "i2pwinupdate.su3.torrent" "$I2P_SNARK_DIR"
        sudo chown i2psvc:i2psvc "$I2P_SNARK_DIR/i2pwinupdate.su3" "$I2P_SNARK_DIR/i2pwinupdate.su3.torrent"
    fi
fi