-include i2pversion
-include i2pversion_override

-include config.mk

preset=`rm .version; make version`

-include .version

PROFILE_VERSION=$(VERSIONMAJOR).$(VERSIONMINOR).$(VERSIONBUILD)

all: version prep install.exe

fmt:
	find . -name '*.java' -exec clang-format -i {} \;

tag:
	git tag $(PROFILE_VERSION)

version:
	echo !define VERSIONMAJOR $(VERSIONMAJOR) > src/nsis/i2pbrowser-version.nsi
	echo !define VERSIONMINOR $(VERSIONMINOR) >> src/nsis/i2pbrowser-version.nsi
	echo !define VERSIONBUILD $(VERSIONBUILD) >> src/nsis/i2pbrowser-version.nsi
	sed 's|!define VERSION||g' src/nsis/i2pbrowser-version.nsi | sed 's| |=|g' > .version
	rm -f version.txt
	make version.txt i2pbrowser-jpackage.nsi

version.txt: build
	echo "$(PROFILE_VERSION)" > build/version.txt
	echo "$(PROFILE_VERSION)" > build/version.txt

i2pbrowser-jpackage.nsi:
	echo "!define I2P_VERSION $(PROFILE_VERSION)" > src/nsis/i2pbrowser-jpackage.nsi

jpackage: version I2P build/I2P/config all

help: version
	@echo "I2P-Easy-Install-Bundle-$(PROFILE_VERSION)"
	@echo "$(SIGNER)"
	@echo "$(I2P_VERSION)"
	@echo "$(MAJOR).$(MINOR).$(BUILD)"
	@echo "$(preset)"

prep:
	make build/licenses
	echo "licenses" >>make.log
	make build/I2P
	echo "buildi2p" >>make.log
	make build/I2P/config
	echo "buildi2pconfig" >>make.log
	cp src/nsis/*.nsi build
	echo "nsi1" >>make.log
	cp src/nsis/*.nsh build
	echo "nsi2" >>make.log
	cp src/icons/*.ico build

install.exe: #build/licenses
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Easy-Install-Bundle-*.exe ../ && echo "built windows installer"

export RES_DIR="../i2p.i2p.jpackage-build/installer/resources"
export PKG_DIR="../i2p.i2p.jpackage-build/pkg-temp"
export I2P_JBIGI="../i2p.i2p.jpackage-build/installer/lib/jbigi"

distclean: clean
	rm -rf I2P

I2P:
	./build.sh

build/I2P: I2P build
	rm -rf build/I2P
	cp -rv I2P build/I2P ; true
	cp "$(I2P_JBIGI)"/*windows*.dll build/I2P/runtime/lib; true

src/I2P/config:
	mkdir -p src/I2P/config
	rm -rf src/I2P/config/geoip src/I2P/config/webapps src/I2P/config/certificates
	cp -v $(RES_DIR)/clients.config src/I2P/config/
	cp -v $(RES_DIR)/wrapper.config src/I2P/config/
	#grep -v 'router.updateURL' $(RES_DIR)/router.config > src/I2P/config/router.config
	cat router.config > src/I2P/config/router.config
	cat i2ptunnel.config > src/I2P/config/i2ptunnel.config
	cp -v $(RES_DIR)/hosts.txt src/I2P/config/hosts.txt
	cp -R $(RES_DIR)/certificates src/I2P/config/certificates
	cp -R $(RES_DIR)/eepsite src/I2P/config/eepsite
	mkdir -p src/I2P/config/geoip
	cp -v $(RES_DIR)/GeoLite2-Country.mmdb.gz src/I2P/config/geoip/GeoLite2-Country.mmdb.gz
	cp -R "$(PKG_DIR)"/webapps src/I2P/config/webapps
	cd src/I2P/config/geoip && gunzip GeoLite2-Country.mmdb.gz; cd ../../..

build/I2P/config: src/I2P/config build/I2P
	cp -rv src/I2P/config build/I2P/config
#	cp -rv build/I2P/* I2P/
#	cp -rv src/I2P/config build/I2P/.i2p

#
# Warning: a displayed license file of more than 28752 bytes
# will cause makensis V3.03 to crash.
# Possibly related: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=895064
#
build/licenses: build
	mkdir -p build/licenses
	cp license/* build/licenses
	cp LICENSE.md build/licenses/MIT.txt
	cat build/licenses/LICENSE.index \
		build/licenses/EPL.txt \
		build/licenses/GPL+CLASSPATH.txt \
		build/licenses/HTTPS-Everywhere.txt \
		build/licenses/LICENSE.tor \
		build/licenses/MIT.txt \
		build/licenses/MPL2.txt \
		build/licenses/NoScript.txt \
		build/licenses/NSS.txt \
		build/licenses/I2P.txt > build/licenses/LICENSE.txt
	unix2dos build/licenses/LICENSE.txt

clean:
	rm -rf build app-profile-*.tgz profile-*.tgz I2P-Easy-Install-Bundle-*.exe *.deb src/I2P/config *.su3 .version *.url make.log
	git clean -fdx src build

build:
	@echo "creating build directory"
	mkdir -p build

include makefiles/su.mk

include makefiles/su-unsigned.mk

include makefiles/debian.mk

I2P_DATE=`date +%Y-%m-%d`

MAGNET=`bttools torrent dumpinfo i2pwinupdate.su3.torrent | grep 'Magnet' | sed 's|Magnet: ||g' | sed 's|%3A|:|g'| sed 's|%2F|/|g'`
MAGNET_TESTING=`bttools torrent dumpinfo i2pwinupdate-testing.su3.torrent | grep 'MagNet' | sed 's|MagNet: ||g' | sed 's|%3A|:|g'| sed 's|%2F|/|g'`

magnet:
	echo "$(MAGNET)"

BLANK=`awk '! NF { print NR; exit }' changelog.txt`

I2P.zip: I2P-jpackage-windows-$(I2P_VERSION).zip

I2P-jpackage-windows-$(I2P_VERSION).zip:
	sh -c 'powershell Compress-Archive I2P I2P-jpackage-windows-$(I2P_VERSION).zip || zip I2P-jpackage-windows-$(I2P_VERSION).zip -r I2P'

changelog:
	head -n "$(BLANK)" changelog.txt

release-jpackage: I2P-jpackage-windows-$(I2P_VERSION).zip
	head -n "$(BLANK)" changelog.txt | gothub release -p -u eyedeekay -r i2p -t i2p-jpackage-windows-$(I2P_VERSION) -n i2p-jpackage-windows-$(I2P_VERSION) -d -; true

update-release-jpackage:
	head -n "$(BLANK)" changelog.txt | gothub edit -p -u eyedeekay -r i2p -t i2p-jpackage-windows-$(I2P_VERSION) -n i2p-jpackage-windows-$(I2P_VERSION) -d -; true

delete-release-jpackage:
	gothub delete -u eyedeekay -r i2p -t i2p-jpackage-windows-$(I2P_VERSION); true

upload-release-jpackage:
	gothub upload -R -u eyedeekay -r i2p -t i2p-jpackage-windows-$(I2P_VERSION) -n "i2p-jpackage-windows-$(I2P_VERSION)" -f "./I2P-jpackage-windows-$(I2P_VERSION).zip"

jpackage-release: release-jpackage upload-release-jpackage
