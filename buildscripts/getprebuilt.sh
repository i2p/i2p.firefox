#! /usr/bin/env bash
set -e 

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f config_overide.sh ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

"$SCRIPT_DIR"/buildscripts/version.sh
"$SCRIPT_DIR"/buildscripts/licenses.sh

. "$HOME/github-release-config.sh"

if [ -z $TODAYSDATE ]; then
  TODAYSDATE=$(date -d '-1 day' '+%Y%m%d')
fi

if [ ! -f I2P.zip ]; then
  echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
  github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
fi
unzip -FF -l I2P.zip; true
for file in *\\*; do target="${file//\\//}"; mkdir -p "${target%/*}"; mv -v "$file" "$target"; done
echo "unzipped prebuilt router"
sleep 3
"$SCRIPT_DIR"/buildscripts/fixperms.sh

cp "$I2P_PKG/licenses/"* license/
cp "$SCRIPT_DIR/../i2p.i2p.jpackage-build/LICENSE.txt" license/I2P.txt

echo "moved prebuilt router"

mkdir -p "$SCRIPT_DIR"/build/I2P
cp -rv "$SCRIPT_DIR"/I2P/* "$SCRIPT_DIR"/build/I2P
cp -rv src/I2P/config build/I2P/config