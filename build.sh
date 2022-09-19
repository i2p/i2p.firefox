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

. "$SCRIPT_DIR/launcher.sh"

if [ -z $I2P_VERSION ]; then 
    I2P_VERSION=$("$JAVA_HOME"/bin/java -cp build/router.jar net.i2p.router.RouterVersion | sed "s/.*: //" | head -n 1 | sed 's|-|.|g')
fi
echo "preparing to invoke jpackage for I2P version $I2P_VERSION"

rm -rf I2P

make src/I2P/config

"$JAVA_HOME"/bin/jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
  --verbose \
  --java-options "-Xmx512m" \
  --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
  --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
  $JPACKAGE_OPTS \
  --resource-dir build \
  --app-content src/I2P/config \
  --input build --main-jar launcher.jar --main-class net.i2p.router.WinLauncher

cp "$I2P_PKG/licenses/"* license/
cp "$HERE/../i2p.i2p.jpackage-build/LICENSE.txt" license/I2P.txt
