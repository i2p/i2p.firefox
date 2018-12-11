all: build/license-all.txt profile.tgz

build/license-all.txt: build
	cat license/LICENSE.index LICENSE license/MPL2.txt license/LICENSE.tor license/HTTPS-Everywhere.txt license/NoScript.txt > build/license-all.txt
	unix2dos build/license-all.txt


clean:
	rm -rf build profile.tgz


build:
	@echo "creating build directory"
	mkdir build

profile.tgz: build/profile/user.js build/profile/bookmarks.html \
	     build/profile/extensions/NoScript.xpi build/profile/extensions/HTTPSEverywhere.xpi
	@echo "building profile tarball"
	cd build && tar -czf profile.tgz profile && cp profile.tgz ../

build/profile/user.js: build/profile src/profile/user.js
	cp src/profile/user.js build/profile/user.js

build/profile/bookmarks.html: build/profile src/profile/bookmarks.html
	cp src/profile/bookmarks.html build/profile/bookmarks.html

build/profile/extensions/NoScript.xpi: build/profile/extensions NoScript.url
	curl `cat NoScript.url` > build/profile/extensions/NoScript.xpi

build/profile/extensions/HTTPSEverywhere.xpi : build/profile/extensions HTTPSEverywhere.url
	curl `cat HTTPSEverywhere.url` > build/profile/extensions/HTTPSEverywhere.xpi

build/profile/extensions: build/profile
	mkdir build/profile/extensions

build/profile:
	mkdir build/profile
