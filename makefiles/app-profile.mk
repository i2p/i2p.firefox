app-profile: .version build/app-profile/user.js build/app-profile/prefs.js build/app-profile/chrome/userChrome.css build/app-profile/storage-sync.sqlite

app-profile.tgz: app-profile
#	$(eval PROFILE_VERSION := $(shell cat src/app-profile/version.txt))
	@echo "building app-profile tarball $(PROFILE_VERSION)"
	sh -c 'ls build/I2P && cp -rv build/I2P build/app-profile/I2P'; true
	install -m755 src/unix/i2pconfig.sh build/app-profile/i2pconfig.sh
	cd build && tar -czf app-profile-$(PROFILE_VERSION).tgz app-profile && cp app-profile-$(PROFILE_VERSION).tgz ../

build/app-profile/storage-sync.sqlite: build/app-profile src/app-profile/storage-sync.sqlite
	cp src/app-profile/storage-sync.sqlite build/app-profile/storage-sync.sqlite
