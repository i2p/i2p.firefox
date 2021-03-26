all: profile.tgz app-profile.tgz install.exe

install.exe: profile build/licenses build/I2P
	cp src/nsis/*.nsi build
	cp src/nsis/*.nsh build
	cp src/icons/*.ico build
	cd build && makensis i2pbrowser-installer.nsi && cp I2P-Profile-Installer-*.exe ../ && echo "built windows installer"

build/I2P:
	rm -rf build/I2P
	cp -rv I2P build/I2P

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
	rm -rf build app-profile-*.tgz profile-*.tgz I2P-Profile-Installer-*.exe *.deb

build:
	@echo "creating build directory"
	mkdir -p build

profile: build/profile/user.js build/profile/prefs.js build/profile/bookmarks.html build/profile/storage-sync.sqlite copy-xpi

profile.tgz: profile
	$(eval PROFILE_VERSION := $(shell cat src/profile/version.txt))
	@echo "building profile tarball $(PROFILE_VERSION)"
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

copy-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/i2ppb@eyedeekay.github.io.xpi build/profile/extensions
	cp build/NoScript.xpi "build/profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/HTTPSEverywhere.xpi "build/profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2ppb@eyedeekay.github.io.xpi build/profile/extensions/i2ppb@eyedeekay.github.io.xpi

app-profile: build/app-profile/user.js build/app-profile/prefs.js build/app-profile/chrome/userChrome.css build/app-profile/bookmarks.html build/app-profile/storage-sync.sqlite copy-app-xpi

app-profile.tgz: app-profile
	$(eval PROFILE_VERSION := $(shell cat src/app-profile/version.txt))
	@echo "building app-profile tarball $(PROFILE_VERSION)"
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

copy-app-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/i2ppb@eyedeekay.github.io.xpi build/app-profile/extensions
	cp build/HTTPSEverywhere.xpi "build/app-profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2ppb@eyedeekay.github.io.xpi build/app-profile/extensions/i2ppb@eyedeekay.github.io.xpi

build/i2ppb@eyedeekay.github.io.xpi:
	curl -L `cat i2psetproxy.url` > build/i2ppb@eyedeekay.github.io.xpi

build/NoScript.xpi: NoScript.url
	curl `cat NoScript.url` > build/NoScript.xpi

build/HTTPSEverywhere.xpi : HTTPSEverywhere.url
	curl `cat HTTPSEverywhere.url` > build/HTTPSEverywhere.xpi

clean-extensions:
	rm -fv i2psetproxy.url NoScript.url HTTPSEverywhere.url

extensions:HTTPSEverywhere.url NoScript.url i2psetproxy.url

HTTPSEverywhere.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3716461/"`./amo-version.sh https-everywhere`"/https_everywhere-"`./amo-version.sh https-everywhere`"-an+fx.xpi" > HTTPSEverywhere.url

NoScript.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3534184/"`./amo-version.sh noscript`"/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi" > NoScript.url

i2psetproxy.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3674169/"`./amo-version.sh i2p-in-private-browsing`"/i2ppb@eyedeekay.github.io.xpi" > i2psetproxy.url

build/profile/extensions: build/profile
	mkdir -p build/profile/extensions

build/profile: build
	mkdir -p build/profile
	

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

checkinstall:
	checkinstall \
		--default \
		--install=no \
		--fstrans=yes \
		--pkgname=i2p-firefox \
		--pkgversion=$(PROFILE_VERSION) \
		--pkggroup=net \
		--pkgrelease=1 \
		--pkgsource="https://i2pgit.org/i2p-hackers/i2p.firefox" \
		--maintainer="hankhill19580@gmail.com" \
		--requires="firefox,wget,i2p,i2p-router" \
		--suggests="i2p,i2p-router,syndie,tor,tsocks" \
		--nodoc \
		--deldoc=yes \
		--deldesc=yes \
		--backup=no
