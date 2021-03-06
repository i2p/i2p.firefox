all: profile.tgz app-profile.tgz install.exe

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
	rm -rf build app-profile-*.tgz profile-*.tgz I2P-Profile-Installer-*.exe

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
	install -m755 src/unix/i2pbrowser.sh build/app-profile/i2pbrowser.sh
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
