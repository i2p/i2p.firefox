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
echo "version set"
"$SCRIPT_DIR"/buildscripts/licenses.sh
echo "licenses generated"
. "$HOME/github-release-config.sh"

if [ -z $TODAYSDATE ]; then
  TODAYSDATE=$(date -d '-1 day' '+%Y%m%d')
fi

if [ ! -f I2P.zip ]; then
  echo github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
  github-release download -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "I2P.zip" -t "$TODAYSDATE"
fi
unzip -FF I2P.zip || true
echo "unzipped prebuilt router"
sleep 3
"$SCRIPT_DIR"/buildscripts/fixperms.sh

echo "moved prebuilt router"

cd "$SCRIPT_DIR"

export I2P_PKG="$SCRIPT_DIR/../i2p.i2p.jpackage-build/pkg-temp"
export RES_DIR="$SCRIPT_DIR/../i2p.i2p.jpackage-build/installer/resources"
export I2P_JARS="$I2P_PKG/lib"
export I2P_JBIGI="$SCRIPT_DIR/../i2p.i2p.jpackage-build/installer/lib/jbigi"
export I2P_JBIGI_JAR="$SCRIPT_DIR/../i2p.i2p.jpackage-build/build/jbigi.jar"

mkdir -p "$SCRIPT_DIR/src/I2P/config"
rm -rf "$SCRIPT_DIR/src/I2P/config/geoip" "$SCRIPT_DIR/src/I2P/config/webapps" "$SCRIPT_DIR/src/I2P/config/certificates"
cp -v "$RES_DIR/clients.config" "$SCRIPT_DIR/src/I2P/config/"
cp -v "$RES_DIR/wrapper.config" "$SCRIPT_DIR/src/I2P/config/"
#grep -v 'router.updateURL' $(RES_DIR)/router.config > "$SCRIPT_DIR"/src/I2P/config/router.config
cat router.config > "$SCRIPT_DIR/src/I2P/config/router.config"
cat i2ptunnel.config > "$SCRIPT_DIR/src/I2P/config/i2ptunnel.config"
cp -v "$RES_DIR/hosts.txt" "$SCRIPT_DIR/src/I2P/config/hosts.txt"
cp -r "$RES_DIR/certificates" "$SCRIPT_DIR/src/I2P/config/certificates"
cp -r "$RES_DIR/eepsite" "$SCRIPT_DIR/src/I2P/config/eepsite"
mkdir -p "$SCRIPT_DIR/src/I2P/config/geoip"
cp -v "$RES_DIR/GeoLite2-Country.mmdb.gz" "$SCRIPT_DIR/src/I2P/config/geoip/GeoLite2-Country.mmdb.gz"
#cp -r "$I2P_PKG/webapps" "$SCRIPT_DIR/src/I2P/config/webapps"
cd "$SCRIPT_DIR/src/I2P/config/geoip" && gunzip GeoLite2-Country.mmdb.gz; cd "$SCRIPT_DIR"

mkdir -p "$SCRIPT_DIR"/build/I2P
cp -rv "$SCRIPT_DIR"/I2P/* "$SCRIPT_DIR"/build/I2P
cp -rv "$SCRIPT_DIR"/src/I2P/config "$SCRIPT_DIR"/build/I2P/config