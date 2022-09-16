
profile: build/profile/user.js build/profile/prefs.js build/profile/storage-sync.sqlite

profile.tgz: .version profile
#	$(eval PROFILE_VERSION := $(shell cat src/profile/version.txt))
	@echo "building profile tarball $(PROFILE_VERSION)"
	sh -c 'ls build/I2P && cp -rv build/I2P build/profile/I2P'; true
	install -m755 src/unix/i2pbrowser.sh build/profile/i2pbrowser.sh
	cd build && tar -czf profile-$(PROFILE_VERSION).tgz profile && cp profile-$(PROFILE_VERSION).tgz ../

build/profile/storage-sync.sqlite: build/profile src/profile/storage-sync.sqlite
	cp src/profile/storage-sync.sqlite build/profile/storage-sync.sqlite
