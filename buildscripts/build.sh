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

if [ -z $machine ]; then
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
fi

ICON="$SCRIPT_DIR/src/icons/ui2pbrowser_icon.ico"

if [ "$machine" = "Mac" ]; then
  rm -rf I2P
  "$SCRIPT_DIR"/buildscripts/getprebuilt.sh
  exit 0
elif [ "$machine" = "Linux" ]; then
  rm -rf I2P
  "$SCRIPT_DIR"/buildscripts/getprebuilt.sh
  exit 0
elif [ "$machine" = "unix" ]; then
  ICON="$SCRIPT_DIR"/src/icons/windowsUIToopie2.png
  export EXTRACODE="unix"
  export EXTRA="    public final static String EXTRA = \"-$EXTRACODE\";"
fi

. "$SCRIPT_DI"$SCRIPT_DIR"/buildscripts/launcher.sh"

if [ -z $I2P_VERSION ]; then 
    I2P_VERSION=$("$JAVA_HOME"/bin/java -cp $SCRIPT_DIR/build/router.jar net.i2p.router.RouterVersion | sed "s/.*: //" | head -n 1 | sed 's|-|.|g')
fi

echo "preparing to invoke jpackage for I2P version $I2P_VERSION"

rm -rf I2P

if [ ! -d "I2P" ]; then
"$JAVA_HOME"/bin/jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
  --verbose \
  --java-options "-Xmx512m" \
  --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
  --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
  --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
  $JPACKAGE_OPTS \
  --resource-dir $SCRIPT_DIR/build \
  --app-content "$SCRIPT_DIR"/src/I2P/config \
  --app-content "$SCRIPT_DIR"/src/unix/torbrowser.sh \
  --app-content "$SCRIPT_DIR"/src/win/torbrowser-windows.sh \
  --app-content "$SCRIPT_DIR"/src/icons/windowsUIToopie2.png \
  --app-content "$SCRIPT_DIR"/src/icons/ui2pbrowser_icon.ico \
  --icon "${ICON}" \
  --input $SCRIPT_DIR/build --main-jar launcher.jar --main-class net.i2p.router.WinLauncher
fi

cp "$I2P_PKG/licenses/"* license/
cp "$SCRIPT_DIR/../i2p.i2p.jpackage-build/LICENSE.txt" license/I2P.txt
