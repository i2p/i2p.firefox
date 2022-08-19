
profile: build/profile/user.js build/profile/prefs.js build/profile/bookmarks.html build/profile/storage-sync.sqlite copy-xpi

profile.tgz: .version profile
#	$(eval PROFILE_VERSION := $(shell cat src/profile/version.txt))
	@echo "building profile tarball $(PROFILE_VERSION)"
	sh -c 'ls build/I2P && cp -rv build/I2P build/profile/I2P'; true
	install -m755 src/unix/i2pbrowser.sh build/profile/i2pbrowser.sh
	cd build && tar -czf profile-$(PROFILE_VERSION).tgz profile && cp profile-$(PROFILE_VERSION).tgz ../

src/profile/user.js:
	wget -O src/profile/user.js "https://github.com/arkenfox/user.js/raw/master/user.js"
	sed -i 's|user_pref("extensions.autoDisableScopes", 15);|user_pref("extensions.autoDisableScopes", 0);|g src/profile/user.js
	sed -i 's|user_pref("extensions.enabledScopes", 5);|user_pref("extensions.enabledScopes", 1);|g' src/profile/user.js

build/profile/user.js: build/profile src/profile/user.js
	cp src/profile/user.js build/profile/user.js
	cp src/profile/user-overrides.js build/profile/user-overrides.js

build/profile/prefs.js: build/profile src/profile/prefs.js
	cp src/profile/prefs.js build/profile/prefs.js

build/profile/bookmarks.html: build/profile src/profile/bookmarks.html
	cp src/profile/bookmarks.html build/profile/bookmarks.html

build/profile/storage-sync.sqlite: build/profile src/profile/storage-sync.sqlite
	cp src/profile/storage-sync.sqlite build/profile/storage-sync.sqlite

copy-xpi: build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi build/https-everywhere-eff@eff.org.xpi build/i2ppb@eyedeekay.github.io.xpi build/profile/extensions
	cp build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi "build/profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/https-everywhere-eff@eff.org.xpi "build/profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2ppb@eyedeekay.github.io.xpi build/profile/extensions/i2ppb@eyedeekay.github.io.xpi
