all: build/license-all.txt profile.tgz

build/license-all.txt: build
	cat license/LICENSE.index LICENSE license/MPL2.txt license/LICENSE.tor license/HTTPS-Everywhere.txt license/NoScript.txt > build/license-all.txt
	unix2dos build/license-all.txt


clean:
	rm -rf build profile.tgz


build:
	@echo "creating build directory"
	mkdir build

profile.tgz: build/profile/user.js build/profile/bookmarks.html copy-xpi
	@echo "building profile tarball"
	cd build && tar -czf profile.tgz profile && cp profile.tgz ../

build/profile/user.js: build/profile src/profile/user.js
	cp src/profile/user.js build/profile/user.js

build/profile/bookmarks.html: build/profile src/profile/bookmarks.html
	cp src/profile/bookmarks.html build/profile/bookmarks.html

copy-xpi: build/NoScript.xpi build/HTTPSEverywhere.xpi build/profile/extensions
	cp build/NoScript.xpi "build/profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
	cp build/HTTPSEverywhere.xpi "build/profile/extensions/https-everywhere-eff@eff.org.xpi"

build/NoScript.xpi: build/ NoScript.url
	curl `cat NoScript.url` > build/NoScript.xpi

build/HTTPSEverywhere.xpi : build HTTPSEverywhere.url
	curl `cat HTTPSEverywhere.url` > build/HTTPSEverywhere.xpi

build/profile/extensions: build/profile
	mkdir build/profile/extensions

build/profile:
	mkdir build/profile
