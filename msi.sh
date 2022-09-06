#! /usr/bin/env sh

## EXPERIMENTAL. PROBABLY WON'T SEE THE LIGHT OF DAY BUT MAYBE I GET LUCKY.

. ./config.sh
. ./i2pversion
jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
    --verbose \
    --java-options "-Xmx512m" \
    --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
    --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
    $JPACKAGE_OPTS \
    --resource-dir build \
    --input build \
    --verbose \
    --type msi \
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
