#!/bin/bash

. i2pversion

if [ -f i2pversion_override ]; then
    . i2pversion_override
fi

. config.sh

if [ -f config_overide.sh ]; then
    . config_override.sh
fi

linuxsign() {
    if [ ! -f jsign-4.1.jar ]; then
        wget -O jsign-4.1.jar https://github.com/ebourg/jsign/releases/download/4.1/jsign-4.1.jar
    fi
    java -jar jsign-4.1.jar \
    -keystore "$JAVA_HOME/lib/security/cacerts" \
    -storepass changeit \
    -keyfile "$HOME/signingkeys/signing-key.jks" \
    -keypass changeit \
    -tsaurl "http://timestamp.sectigo.com" \
    -name "I2P-Browser-Installer" \
    -alg "SHA-512" \
    "$1"
}

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    JAVA_HOME=`type -p java|xargs readlink -f|xargs dirname|xargs dirname`
    linuxsign I2P-Profile-Installer-$I2P_VERSION.exe
    cp "I2P-Profile-Installer-$I2P_VERSION.exe" "I2P-Profile-Installer-$I2P_VERSION-signed.exe"
else
    signtool sign "I2P-Profile-Installer-$I2P_VERSION.exe"
    cp "I2P-Profile-Installer-$I2P_VERSION.exe" "I2P-Profile-Installer-$I2P_VERSION-signed.exe"
fi
