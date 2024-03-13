#!/bin/bash

TORSOCKS=$(which torsocks)
#if [ -f "${TORSOCKS}" ]; then
#    . "${TORSOCKS}" on
#fi

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

if [ ! -f "tor-browser-linux64-${version}_${locale}.exe" ]; then
    wget -cv "https://dist.torproject.org/torbrowser/${version}/tor-browser-windows-x86_64-portable-${version}.exe"
    wget -cv "https://dist.torproject.org/torbrowser/${version}/tor-browser-windows-x86_64-portable-${version}.exe.asc"
fi

gpgv --keyring ./tor.keyring "tor-browser-windows-x86_64-portable-${version}.exe.asc" "tor-browser-windows-x86_64-portable-${version}.exe"

7z x "tor-browser-windows-x86_64-portable-${version}.exe" -o "Tor Browser"
7z --help