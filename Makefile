-include i2pversion
-include i2pversion_override

-include config.mk

preset=`rm .version; make version`

-include .version

PROFILE_VERSION=$(VERSIONMAJOR).$(VERSIONMINOR).$(VERSIONBUILD)

all: version install.exe

fmt:
	find . -name '*.java' -exec clang-format -i {} \;

tag:
	git tag $(PROFILE_VERSION)

version:
	./buildscripts/version.sh

jpackage: version I2P build/I2P/config all

help: version
	@echo "I2P-Easy-Install-Bundle-$(PROFILE_VERSION)"
	@echo "$(SIGNER)"
	@echo "$(I2P_VERSION)"
	@echo "$(MAJOR).$(MINOR).$(BUILD)"
	@echo "$(preset)"

prep:
	cp src/nsis/*.nsi build
	echo "nsi1" >> make.log
	cp src/nsis/*.nsh build
	echo "nsi2" >> make.log
	cp src/icons/*.ico build

install.exe: prep
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Easy-Install-Bundle-*.exe ../ && echo "built windows installer"

export RES_DIR="../i2p.i2p.jpackage-build/installer/resources"
export PKG_DIR="../i2p.i2p.jpackage-build/pkg-temp"
#export I2P_JBIGI="../i2p.i2p.jpackage-build/installer/lib/jbigi"

distclean: clean
	rm -rf I2P

I2P:
	./buildscripts/build.sh

build/I2P: I2P build

src/I2P/config:

build/I2P/config: src/I2P/config build/I2P

#
# Warning: a displayed license file of more than 28752 bytes
# will cause makensis V3.03 to crash.
# Possibly related: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=895064
#
build/licenses: build
	./buildscripts/licenses.sh

clean:
	./buildscripts/clean.sh

build:
	@echo "creating build directory"
	mkdir -p build

include makefiles/su.mk

include makefiles/su-unsigned.mk

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
