-include i2pversion
-include i2pversion_override

-include config.mk

preset=`rm .version; make version`

-include .version

PROFILE_VERSION=$(VERSIONMAJOR).$(VERSIONMINOR).$(VERSIONBUILD)

all: version install.exe

fmt:
	find . -name '*.java' -exec clang-format -i {} \;

version:
	./buildscripts/version.sh

jpackage: version I2P build/I2P all

help: version
	@echo "I2P-Easy-Install-Bundle-$(PROFILE_VERSION)"
	@echo "$(I2P_VERSION)"
	@echo "$(MAJOR).$(MINOR).$(BUILD)"
	@echo "$(preset)"

install.exe:
	./buildscripts/unsigned.sh

distclean: clean
	rm -rf I2P

I2P:
	./buildscripts/build.sh

build/I2P: I2P build
	cp -v I2P build/I2P

build/I2P: build/I2P

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

