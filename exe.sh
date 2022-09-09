#! /usr/bin/env sh

## EXPERIMENTAL. PROBABLY WON'T SEE THE LIGHT OF DAY BUT MAYBE I GET LUCKY.

# Motivation

. ./config.sh
. ./i2pversion
jpackage --name I2P-EXE --app-version "$I2P_VERSION" \
    --verbose \
    --java-options "-Xmx512m" \
    --java-options "--add-opens java.base/java.lang=ALL-UNNAMED" \
    --java-options "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.nio=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties=ALL-UNNAMED" \
    --java-options "--add-opens java.base/java.util.Properties.defaults=ALL-UNNAMED" \
    $JPACKAGE_OPTS \
    --app-content build/I2P/config/certificates \
    --app-content build/I2P/config/eepsite \
    --app-content build/I2P/config/geoip \
    --app-content build/I2P/config/webapps \
    --app-content build/I2P/config/clients.config \
    --app-content build/I2P/config/hosts.txt \
    --app-content build/I2P/config/i2ptunnel.config \
    --app-content build/I2P/config/jpackaged \
    --app-content build/I2P/config/router.config \
    --app-content build/I2P/config/wrappper.config \
    --input build \
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
