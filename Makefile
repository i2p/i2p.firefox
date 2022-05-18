-include i2pversion
-include i2pversion_override

-include config.mk

preset=`rm .version; make .version`

include .version

PROFILE_VERSION=$(MAJOR).$(MINOR).$(BUILD)

all: .version prep install.exe

tag:
	git tag $(PROFILE_VERSION)

.version:
	sed 's|!define VERSION||g' src/nsis/i2pbrowser-version.nsi | sed 's| |=|g' > .version
	rm -f version.txt
	make version.txt i2pbrowser-jpackage.nsi

version.txt:
	echo "$(PROFILE_VERSION)" > src/profile/version.txt
	echo "$(PROFILE_VERSION)" > src/app-profile/version.txt

i2pbrowser-jpackage.nsi:
	echo "!define I2P_VERSION $(I2P_VERSION)" > src/nsis/i2pbrowser-jpackage.nsi

jpackage: .version I2P build/I2P/config all

help: .version
	@echo "I2P-Profile-Installer-$(PROFILE_VERSION)"
	@echo "$(SIGNER)"
	@echo "$(I2P_VERSION)"
	@echo "$(MAJOR).$(MINOR).$(BUILD)"
	@echo "$(preset)"

prep: #launchers build/licenses profile.tgz app-profile.tgz profile build/I2P build/I2P/config #
	make launchers
	echo "launchers" >make.log
	make build/licenses
	echo "licenses" >make.log
	make profile.tgz
	echo "profilezip" >make.log
	make app-profile.tgz
	echo "appprofile" >make.log
	make profile 
	echo "profile" >make.log
	make build/I2P
	echo "buildi2p" >make.log
	make build/I2P/config
	echo "buildi2pconfig" >make.log
	cp src/nsis/*.nsi build
	echo "nsi1" >make.log
	cp src/nsis/*.nsh build
	echo "nsi2" >make.log
	cp src/icons/*.ico build

install.exe: #build/licenses
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Profile-Installer-*.exe ../ && echo "built windows installer"

export RES_DIR="../i2p.i2p.jpackage-build/installer/resources"
export PKG_DIR="../i2p.i2p.jpackage-build/pkg-temp"
export I2P_JBIGI="../i2p.i2p.jpackage-build/installer/lib/jbigi"

distclean: clean clean-extensions
	rm -rf I2P
	git clean -fd

I2P:
	./build.sh

build/I2P: I2P build
	rm -rf build/I2P
	cp -rv I2P build/I2P ; true
	cp "$(I2P_JBIGI)"/*windows*.dll build/I2P/runtime/lib; true

src/I2P/config: build/I2P
	mkdir -p src/I2P/config
	rm -rf src/I2P/config/geoip src/I2P/config/webapps src/I2P/config/certificates
	echo true | tee src/I2P/config/jpackaged
	cp -v $(RES_DIR)/clients.config src/I2P/config/
	cp -v $(RES_DIR)/i2ptunnel.config src/I2P/config/
	cp -v $(RES_DIR)/wrapper.config src/I2P/config/
	#grep -v 'router.updateURL' $(RES_DIR)/router.config > src/I2P/config/router.config
	cat router.config > src/I2P/config/router.config
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
	unix2dos build/licenses/LICENSE.index

clean:
	rm -rf build app-profile-*.tgz profile-*.tgz I2P-Profile-Installer-*.exe *.deb src/I2P/config *.su3 .version *.url make.log
	git clean -fdx src build

build:
	@echo "creating build directory"
	mkdir -p build

include makefiles/profile.mk

include makefiles/app-profile.mk

-include makefiles/new-extensions.mk

include makefiles/extensions.mk

include makefiles/build.mk

include makefiles/install.mk

include makefiles/su.mk

include makefiles/su-unsigned.mk

include makefiles/docker.mk

include makefiles/debian.mk

I2P_DATE=`date +%Y-%m-%d`

MAGNET=`bttools torrent printinfo i2pwinupdate.su3.torrent | grep 'MagNet' | sed 's|MagNet: ||g' | sed 's|%3A|:|g'| sed 's|%2F|/|g'`
MAGNET_TESTING=`bttools torrent printinfo i2pwinupdate-testing.su3.torrent | grep 'MagNet' | sed 's|MagNet: ||g' | sed 's|%3A|:|g'| sed 's|%2F|/|g'`

BLANK=`awk '! NF { print NR; exit }' changelog.txt`

I2P.zip: I2P-jpackage-windows-$(I2P_VERSION).zip

I2P-jpackage-windows-$(I2P_VERSION).zip:
	zip I2P-jpackage-windows-$(I2P_VERSION).zip -r build/I2P

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
