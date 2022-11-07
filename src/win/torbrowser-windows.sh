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
    wget -cv "https://www.torproject.org/dist/torbrowser/${version}/torbrowser-install-win64-${version}_${locale}.exe" 
    wget -cv "https://www.torproject.org/dist/torbrowser/${version}/torbrowser-install-win64-${version}_${locale}.exe.asc"
fi

gpgv --keyring ./tor.keyring "torbrowser-install-win64-${version}_${locale}.exe.asc" "torbrowser-install-win64-${version}_${locale}.exe"

#tar xvJf "torbrowser-install-win64-${version}_${locale}.exe"
#for n in `seq 1 2000`; do echo $n; dd ibs=256 if="torbrowser-install-win64-${version}_${locale}.exe" count=2 skip=$n | file - ; done 2>/dev/null |less
#zip -FF "torbrowser-install-win64-${version}_${locale}.exe" --out extracted.zip
export WINEPREFIX=$(pwd)/../tmp
wine "torbrowser-install-win64-${version}_${locale}.exe" /S #/D .
cp -vr "$WINEPREFIX/drive_c/users/idk/Desktop/Tor Browser/" "Tor Browser"