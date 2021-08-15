-include i2pversion
-include i2pversion_override

-include config.mk

preset=`rm .version; make .version`

include .version

PROFILE_VERSION=$(MAJOR).$(MINOR).$(BUILD)

all: .version install.exe

.version:
	sed 's|!define VERSION||g' src/nsis/i2pbrowser-version.nsi | sed 's| |=|g' > .version
	make version.txt src/nsis/i2pbrowser_jpackage.nsi

version.txt:
	echo "$(PROFILE_VERSION)" > src/profile/version.txt
	echo "$(PROFILE_VERSION)" > src/app-profile/version.txt

src/nsis/i2pbrowser_jpackage.nsi:
	echo "!define I2P_VERSION $(I2P_VERSION)" > src/nsis/i2pbrowser_jpackage.nsi

jpackage: .version I2P all

help: .version
	@echo "I2P-Profile-Installer-$(PROFILE_VERSION)"
	@echo "$(SIGNER)"
	@echo "$(I2P_VERSION)"
	@echo "$(MAJOR).$(MINOR).$(BUILD)"
	@echo "$(preset)"

prep: profile.tgz app-profile.tgz profile build/licenses build/I2P build/I2P/config launchers
	cp src/nsis/*.nsi build
	cp src/nsis/*.nsh build
	cp src/icons/*.ico build

install.exe: prep
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Profile-Installer-*.exe ../ && echo "built windows installer"

export RES_DIR="../i2p.i2p/installer/resources"
export PKG_DIR="../i2p.i2p/pkg-temp"
export I2P_JBIGI="../i2p.i2p/installer/lib/jbigi"

distclean: clean
	rm -rf I2P

I2P:
	./build.sh

build/I2P: build
	rm -rf build/I2P
	cp -rv I2P build/I2P ; true
	cp "$(I2P_JBIGI)"/*windows*.dll build/I2P/runtime/lib; true

configdir: src/I2P/config

src/I2P/config:
	mkdir src/I2P/config
	rm -rf src/I2P/config/geoip src/I2P/config/webapps src/I2P/config/certificates
	echo true | tee src/I2P/config/jpackaged
	cp -v $(RES_DIR)/clients.config src/I2P/config/
	cp -v $(RES_DIR)/i2ptunnel.config src/I2P/config/
	cp -v $(RES_DIR)/wrapper.config src/I2P/config/
	cp -v $(RES_DIR)/hosts.txt src/I2P/config/hosts.txt
	cp -R $(RES_DIR)/certificates src/I2P/config/certificates
	cp -R $(RES_DIR)/eepsite src/I2P/config/eepsite
	mkdir -p src/I2P/config/geoip
	cp -v $(RES_DIR)/GeoLite2-Country.mmdb.gz src/I2P/config/geoip/GeoLite2-Country.mmdb.gz
	cp -R "$(PKG_DIR)"/webapps src/I2P/config/webapps
	cd src/I2P/config/geoip && gunzip GeoLite2-Country.mmdb.gz; cd ../../..

build/I2P/config: build/I2P src/I2P/config
	cp -rv src/I2P/config build/I2P/config ; true
	cp -rv src/I2P/config build/I2P/.i2p ; true

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
	rm -rf build app-profile-*.tgz profile-*.tgz I2P-Profile-Installer-*.exe *.deb src/I2P/config *.su3

build:
	@echo "creating build directory"
	mkdir -p build

profile: build/profile/user.js build/profile/prefs.js build/profile/bookmarks.html build/profile/storage-sync.sqlite copy-xpi

profile.tgz: .version profile
#	$(eval PROFILE_VERSION := $(shell cat src/profile/version.txt))
	@echo "building profile tarball $(PROFILE_VERSION)"
	bash -c 'ls I2P && cp -rv build/I2P build/profile/I2P'; true
	install -m755 src/unix/i2pbrowser.sh build/profile/i2pbrowser.sh
	cd build && tar -czf profile-$(PROFILE_VERSION).tgz profile && cp profile-$(PROFILE_VERSION).tgz ../

build/profile/user.js: build/profile src/profile/user.js
	cp src/profile/user.js build/profile/user.js

build/profile/prefs.js: build/profile src/profile/prefs.js
	cp src/profile/prefs.js build/profile/prefs.js

build/profile/bookmarks.html: build/profile src/profile/bookmarks.html
	cp src/profile/bookmarks.html build/profile/bookmarks.html

build/profile/storage-sync.sqlite: build/profile src/profile/storage-sync.sqlite
	cp src/profile/storage-sync.sqlite build/profile/storage-sync.sqlite

copy-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/i2prhz@eyedeekay.github.io.xpi build/profile/extensions
	cp build/NoScript.xpi "build/profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/HTTPSEverywhere.xpi "build/profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2prhz@eyedeekay.github.io.xpi build/profile/extensions/i2prhz@eyedeekay.github.io.xpi

app-profile: .version build/app-profile/user.js build/app-profile/prefs.js build/app-profile/chrome/userChrome.css build/app-profile/bookmarks.html build/app-profile/storage-sync.sqlite copy-app-xpi

app-profile.tgz: app-profile
#	$(eval PROFILE_VERSION := $(shell cat src/app-profile/version.txt))
	@echo "building app-profile tarball $(PROFILE_VERSION)"
	bash -c 'ls I2P && cp -rv build/I2P build/app-profile/I2P'; true
	install -m755 src/unix/i2pconfig.sh build/app-profile/i2pconfig.sh
	cd build && tar -czf app-profile-$(PROFILE_VERSION).tgz app-profile && cp app-profile-$(PROFILE_VERSION).tgz ../

build/app-profile/user.js: build/app-profile src/app-profile/user.js
	cp src/app-profile/user.js build/app-profile/user.js

build/app-profile/prefs.js: build/app-profile src/app-profile/prefs.js
	cp src/app-profile/prefs.js build/app-profile/prefs.js

build/app-profile/chrome/userChrome.css: build/app-profile/chrome src/app-profile/chrome/userChrome.css
	cp src/app-profile/chrome/userChrome.css build/app-profile/chrome/userChrome.css

build/app-profile/bookmarks.html: build/app-profile src/app-profile/bookmarks.html
	cp src/app-profile/bookmarks.html build/app-profile/bookmarks.html

build/app-profile/storage-sync.sqlite: build/app-profile src/app-profile/storage-sync.sqlite
	cp src/app-profile/storage-sync.sqlite build/app-profile/storage-sync.sqlite

copy-app-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/i2prhz@eyedeekay.github.io.xpi build/app-profile/extensions
	cp build/HTTPSEverywhere.xpi "build/app-profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2prhz@eyedeekay.github.io.xpi build/app-profile/extensions/i2prhz@eyedeekay.github.io.xpi

build/i2prhz@eyedeekay.github.io.xpi:
	curl -L `cat i2psetproxy.url` > build/i2prhz@eyedeekay.github.io.xpi

build/NoScript.xpi: NoScript.url
	curl -L `cat NoScript.url` > build/NoScript.xpi

build/HTTPSEverywhere.xpi : HTTPSEverywhere.url
	curl -L `cat HTTPSEverywhere.url` > build/HTTPSEverywhere.xpi

clean-extensions:
	rm -fv i2psetproxy.url NoScript.url HTTPSEverywhere.url

extensions:HTTPSEverywhere.url NoScript.url i2psetproxy.url

HTTPSEverywhere.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3716461/"`./amo-version.sh https-everywhere`"/https_everywhere-"`./amo-version.sh https-everywhere`"-an+fx.xpi" > HTTPSEverywhere.url

NoScript.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3534184/"`./amo-version.sh noscript`"/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi" > NoScript.url

i2psetproxy.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3784917/"`./amo-version.sh i2pipb-rhizome-variant`"/i2prhz@eyedeekay.github.io" > i2psetproxy.url

build/profile/extensions: build/profile
	mkdir -p build/profile/extensions

build/profile: build
	mkdir -p build/profile

build/win:
	mkdir -p build/win/

build/win/i2pbrowser.bat:
	cp src/win/i2pbrowser.bat build/win/i2pbrowser.bat

build/win/i2pconfig.bat:
	cp src/win/i2pconfig.bat build/win/i2pconfig.bat

build/win/i2pbrowser-private.bat:
	cp src/win/i2pbrowser-private.bat build/win/i2pbrowser-private.bat

launchers: build/win build/win/i2pbrowser.bat build/win/i2pbrowser-private.bat build/win/i2pconfig.bat

build/app-profile/chrome: build/app-profile
	mkdir -p build/app-profile/chrome
	
build/app-profile/extensions: build/app-profile
	mkdir -p build/app-profile/extensions

build/app-profile: build
	mkdir -p build/app-profile

install:
	rm -rfv /etc/i2pbrowser \
		/var/lib/i2pbrowser
	mkdir -p /etc/i2pbrowser \
		/var/lib/i2pbrowser
	install -m644 src/unix/i2pbrowserrc /etc/i2pbrowser/i2pbrowserrc
	install -m644 src/unix/i2pbrowserdebianrc /etc/i2pbrowser/i2pbrowserdebianrc
	install -m755 build/profile/i2pbrowser.sh /usr/local/bin/i2pbrowser
	install -m755 build/app-profile/i2pconfig.sh /usr/local/bin/i2pconfig
	install -m755 src/unix/i2p-config-service-setup.sh /usr/local/bin/i2p-config-service-setup
	cp -vr build/profile /var/lib/i2pbrowser/profile
	cp -vr build/app-profile /var/lib/i2pbrowser/app-profile
	cp -vr src/icons /var/lib/i2pbrowser/icons
	cp src/unix/desktop/i2pbrowser.desktop /usr/share/applications
	cp src/unix/desktop/i2pconfig.desktop /usr/share/applications

uninstall:
	rm -rfv /etc/i2pbrowser \
		/var/lib/i2pbrowser \
		/etc/i2pbrowser/i2pbrowserrc \
		/usr/local/bin/i2pbrowser \
		/usr/local/bin/i2pconfig \
		/usr/local/bin/i2p-config-service-setup \
		/usr/share/applications/i2pbrowser.desktop \
		/usr/share/applications/i2pconfig.desktop

checkinstall: version
	checkinstall \
		--default \
		--install=no \
		--fstrans=yes \
		--pkgname=i2p-firefox \
		--pkgversion=$(PROFILE_VERSION) \
		--pkggroup=net \
		--pkgrelease=1 \
		--pkgsource="https://i2pgit.org/i2p-hackers/i2p.firefox" \
		--maintainer="$(SIGNER)" \
		--requires="firefox,wget" \
		--suggests="i2p,i2p-router,syndie,tor,tsocks" \
		--nodoc \
		--deldoc=yes \
		--deldesc=yes \
		--backup=no

su3:
	su3-tools -name "I2P-Profile-Installer-$(PROFILE_VERSION)" -signer "$(SIGNER)" -version "$(I2P_VERSION)"
