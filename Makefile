all: profile.tgz install.exe

install.exe: profile build/licenses
	cp src/nsis/*.nsi build
	cp src/nsis/*.nsh build
	cp src/icons/*.ico build
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Profile-Installer-*.exe ../ && echo "built windows installer"

#
# Warning: a displayed license file of more than 28752 bytes
# will cause makensis V3.03 to crash.
# Possibly related: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=895064
#
build/licenses: build
	mkdir -p build/licenses
	cp license/* build/licenses
	cp LICENSE build/licenses/MIT.txt
	unix2dos build/licenses/LICENSE.index

clean:
	rm -rf build profile-*.tgz I2P-Profile-Installer-*.exe


build:
	@echo "creating build directory"
	mkdir -p build

profile: build/profile/user.js build/profile/bookmarks.html copy-xpi

profile.tgz: profile
	$(eval PROFILE_VERSION := $(shell cat src/profile/version.txt))
	@echo "building profile tarball $(PROFILE_VERSION)"
	cd build && tar -czf profile-$(PROFILE_VERSION).tgz profile && cp profile-$(PROFILE_VERSION).tgz ../

build/profile/user.js: build/profile src/profile/user.js
	cp src/profile/user.js build/profile/user.js

build/profile/bookmarks.html: build/profile src/profile/bookmarks.html
	cp src/profile/bookmarks.html build/profile/bookmarks.html

copy-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/profile/extensions
	cp build/NoScript.xpi "build/profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/HTTPSEverywhere.xpi "build/profile/extensions/https-everywhere-eff@eff.org.xpi"

build/NoScript.xpi: NoScript.url
	curl `cat NoScript.url` > build/NoScript.xpi

build/HTTPSEverywhere.xpi : HTTPSEverywhere.url
	curl `cat HTTPSEverywhere.url` > build/HTTPSEverywhere.xpi

build/profile/extensions: build/profile
	mkdir -p build/profile/extensions

build/profile: build
	mkdir -p build/profile
