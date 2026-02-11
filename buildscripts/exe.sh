#! /usr/bin/env sh

## EXPERIMENTAL. PROBABLY WON'T SEE THE LIGHT OF DAY BUT MAYBE I GET LUCKY.

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. ./config.sh
. ./i2pversion
./buildscripts/build.sh
if echo "$I2P_VERSION" | grep "master"; then
    RELEASE_VERSION="9.9.9"
else
    RELEASE_VERSION="$I2P_VERSION"
fi
jpackage --name I2P-EXE --app-version "$RELEASE_VERSION" \
    --verbose \
    --java-options "-Xmx512m" \
    --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
    --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
    $JPACKAGE_OPTS \
    --app-content "$SCRIPT_DIR"/src/I2P/config \
    --app-content "$SCRIPT_DIR"/src/icons/windowsUIToopie2.ico \
    --icon "$SCRIPT_DIR"/src/icons/windowsUIToopie2.ico \
    --input "$SCRIPT_DIR/build" \
    --verbose \
    --type exe \
    --win-dir-chooser \
    --win-help-url "https://geti2p.net" \
    --win-menu \
    --win-menu-group "I2P Easy-Install Bundle" \
    --win-shortcut \
    --win-shortcut-prompt \
    --win-per-user-install \
    --license-file LICENSE.md \
    --main-jar launcher.jar \
    --main-class net.i2p.router.WinLauncher
