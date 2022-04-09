#! /usr/bin/env sh

here=$(pwd)
cd ../i2p.i2p.jpackage-build/
ant distclean
cd "$here"
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
	*.app \
	*.jar \
	*.exe \
	*.dmg