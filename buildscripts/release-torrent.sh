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

#cp -v "I2P-Easy-Install-Bundle-$I2P_VERSION.exe" "I2P-Easy-Install-Bundle-$I2P_VERSION-signed.exe"
#java -cp "$HOME/i2p/lib/*" net.i2p.crypto.SU3File sign -c ROUTER -f EXE I2P-Easy-Install-Bundle-$I2P_VERSION-signed.exe I2P-Easy-Install-Bundle-$I2P_VERSION-signed.su3 "$HOME/.i2p-plugin-keys/news-su3-keystore.ks" $I2P_VERSION $SIGNER
#rm -f i2pwinupdate.su3.torrent
#mktorrent \
#		--announce=http://tracker2.postman.i2p/announce.php \
#		--announce=http://w7tpbzncbcocrqtwwm3nezhnnsw4ozadvi2hmvzdhrqzfxfum7wa.b32.i2p/a \
#		--announce=http://mb5ir7klpc2tj6ha3xhmrs3mseqvanauciuoiamx2mmzujvg67uq.b32.i2p/a \
#		i2pwinupdate.su3
ZIPCHECKSUM=$(sha256sum "i2pwinupdate.su3")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "i2pwinupdate.su3" -l "$ZIPCHECKSUM" -t "$I2P_VERSION" -n "i2pwinupdate.su3"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "i2pwinupdate.su3" -l "$ZIPCHECKSUM" -t "$I2P_VERSION" -n "i2pwinupdate.su3"
ZIPCHECKSUM=$(sha256sum "i2pwinupdate.su3.torrent")
echo github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "i2pwinupdate.su3.torrent" -l "$ZIPCHECKSUM" -t "$I2P_VERSION" -n "i2pwinupdate.su3.torrent"
github-release upload -R -u "$GITHUB_USERNAME" -r "i2p.firefox" -f "i2pwinupdate.su3.torrent" -l "$ZIPCHECKSUM" -t "$I2P_VERSION" -n "i2pwinupdate.su3.torrent"
