#! /usr/bin/env bash

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

linuxsign() {
    ## LINUX SIGNING IS EXPERIMENTAL AND SHOULD NOT BE USED IN DEFAULT STATE.
    if [ ! -f jsign-4.1.jar ]; then
        wget -O jsign-4.1.jar https://github.com/ebourg/jsign/releases/download/4.1/jsign-4.1.jar
    fi
    if [ ! -f "$HOME/signingkeys/signing-key.jks" ]; then
        mkdir -p "$HOME/signingkeys/"
        keytool -genkey -alias server-alias -keyalg RSA -keypass changeit \
            -storepass changeit -keystore "$HOME/signingkeys/signing-key.jks"
    fi
    java -jar jsign-4.1.jar \
        --keystore "$HOME/signingkeys/signing-key.jks" \
        --storepass changeit \
        --keypass changeit \
        --tsaurl "http://timestamp.sectigo.com" \
        --name "I2P-Browser-Installer" \
        --alg "SHA-512" \
        "$1"
}

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
    linuxsign I2P-Profile-Installer-$I2P_VERSION.exe
    cp "I2P-Profile-Installer-$I2P_VERSION.exe" "I2P-Profile-Installer-$I2P_VERSION-signed.exe"
else
    signtool.exe sign /a "I2P-Profile-Installer-$I2P_VERSION.exe"
    cp "I2P-Profile-Installer-$I2P_VERSION.exe" "I2P-Profile-Installer-$I2P_VERSION-signed.exe"
fi
