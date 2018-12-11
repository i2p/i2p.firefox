all: build/license-all.txt
	@echo "Doing everything"

build/license-all.txt: build
	cat license/LICENSE.index LICENSE license/MPL2.txt license/LICENSE.tor license/HTTPS-Everywhere.txt license/NoScript.txt > build/license-all.txt
	unix2dos build/license-all.txt


clean:
	rm -rf build


build:
	@echo "creating build directory"
	mkdir build
