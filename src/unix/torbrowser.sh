#!/bin/bash

TORSOCKS=$(which torsocks)
if [ -f "${TORSOCKS}" ]; then
    . "${TORSOCKS}" on
fi

version="$(curl -s https://aus1.torproject.org/torbrowser/update_3/release/downloads.json | jq -r ".version")"
locale="en-US" # mention your locale. default = en-US
if [ -d /etc/default/locale ]; then
    . /etc/default/locale
    locale=$(echo "${LANG}" | cut -d . -f1)
fi

if [ ! -f ./tor.keyring ]; then
    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
    gpg --output ./tor.keyring --export torbrowser@torproject.org
fi

if [ ! -f "tor-browser-linux64-${version}_${locale}.tar.xz" ]; then
    wget -cv "https://www.torproject.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
    https://dist.torproject.org/torbrowser/13.0.9/
    wget -cv "https://www.torproject.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz.asc"
fi

gpgv --keyring ./tor.keyring "tor-browser-linux-x86_64-${version}.tar.xz.asc" "tor-browser-linux-x86_64-${version}.tar.xz"

tar xvJf "tor-browser-linux-x86_64-${version}.tar.xz"
