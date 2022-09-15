app-profile: .version build/app-profile/user.js build/app-profile/prefs.js build/app-profile/chrome/userChrome.css build/app-profile/bookmarks.html build/app-profile/storage-sync.sqlite

app-profile.tgz: app-profile
#	$(eval PROFILE_VERSION := $(shell cat src/app-profile/version.txt))
	@echo "building app-profile tarball $(PROFILE_VERSION)"
	sh -c 'ls build/I2P && cp -rv build/I2P build/app-profile/I2P'; true
	install -m755 src/unix/i2pconfig.sh build/app-profile/i2pconfig.sh
	cd build && tar -czf app-profile-$(PROFILE_VERSION).tgz app-profile && cp app-profile-$(PROFILE_VERSION).tgz ../

src/app-profile/user.js:
	wget -O src/app-profile/user.js "https://github.com/arkenfox/user.js/raw/master/user.js"
	sed -i 's|user_pref("extensions.autoDisableScopes", 15);|user_pref("extensions.autoDisableScopes", 0);|g src/app-profile/user.js
	sed -i 's|user_pref("extensions.enabledScopes", 5);|user_pref("extensions.enabledScopes", 1);|g' src/app-profile/user.js
	sed -i 's|user_pref("dom.security.https_only_mode", true);|user_pref("dom.security.https_only_mode", false);|g' src/app-profile/user.js
	

build/app-profile/user.js: build/app-profile src/app-profile/user.js
	cp src/app-profile/user.js build/app-profile/user.js
	cp src/app-profile/user-overrides.js build/app-profile/user-overrides.js

build/app-profile/prefs.js: build/app-profile src/app-profile/prefs.js
	cp src/app-profile/prefs.js build/app-profile/prefs.js

build/app-profile/chrome/userChrome.css: build/app-profile/chrome src/app-profile/chrome/userChrome.css
	cp src/app-profile/chrome/userChrome.css build/app-profile/chrome/userChrome.css

build/app-profile/bookmarks.html: build/app-profile src/app-profile/bookmarks.html
	cp src/app-profile/bookmarks.html build/app-profile/bookmarks.html

build/app-profile/storage-sync.sqlite: build/app-profile src/app-profile/storage-sync.sqlite
	cp src/app-profile/storage-sync.sqlite build/app-profile/storage-sync.sqlite
