#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/config.sh"
. "$SCRIPT_DIR/i2pversion"

if [ -f config_overide.sh ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

cd ../i2p.i2p.jpackage-build/
ant distclean
git clean -fd
git checkout .
tar --exclude="$SCRIPT_DIR/../i2p.i2p.jpackage-build/.git" -cvzf "$SCRIPT_DIR/../i2p.i2p.jpackage-build.tar.gz" "$SCRIPT_DIR/../i2p.i2p.jpackage-build/"
cd "$SCRIPT_DIR" || exit 1
rm -rf \
	build \
	eventlog.txt \
	hostsdb.blockfile \
	I2P \
	i2p_1.0-1_amd64.deb \
	libjbigi.so \
	libjcpuid.so \
	logs \
	peerProfiles \
	prngseed.rnd \
	wrapper.log \
	*.jar \
	*.exe \
	*.dmg
rm -rf build app-profile-*.tgz profile-*.tgz I2P-Easy-Install-Bundle-*.exe *.deb src/I2P/config *.su3 .version *.url make.log
git clean -fdx src build onionkeys tlskeys i2pkeys
make clean