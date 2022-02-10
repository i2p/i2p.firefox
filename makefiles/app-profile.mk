app-profile: .version build/app-profile/user.js build/app-profile/prefs.js build/app-profile/chrome/userChrome.css build/app-profile/bookmarks.html build/app-profile/storage-sync.sqlite copy-app-xpi

app-profile.tgz: app-profile
#	$(eval PROFILE_VERSION := $(shell cat src/app-profile/version.txt))
	@echo "building app-profile tarball $(PROFILE_VERSION)"
	sh -c 'ls build/I2P && cp -rv build/I2P build/app-profile/I2P'; true
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

copy-app-xpi: build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi build/https-everywhere-eff@eff.org.xpi build/i2ppb@eyedeekay.github.io.xpi build/app-profile/extensions
	cp build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi "build/app-profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/https-everywhere-eff@eff.org.xpi "build/app-profile/extensions/https-everywhere-eff@eff.org.xpi"
	cp build/i2ppb@eyedeekay.github.io.xpi build/app-profile/extensions/i2ppb@eyedeekay.github.io.xpi