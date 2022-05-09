build/profile/extensions: build/profile
	mkdir -p build/profile/extensions

build/profile: build
	mkdir -p build/profile

build/win:
	mkdir -p build/win/

build/win/common.bat:
	cp src/win/common.bat build/win/common.bat

build/win/copy-config-profile.bat:
	cp src/win/copy-config-profile.bat build/win/copy-config-profile.bat

build/win/copy-profile.bat:
	cp src/win/launchi2p.bat build/win/copy-profile.bat

build/win/launchi2p.bat:
	cp src/win/launchi2p.bat build/win/launchi2p.bat

build/win/i2pbrowser.bat: build/win/common.bat build/win/copy-config-profile.bat build/win/copy-profile.bat build/win/launchi2p.bat
	cp src/win/i2pbrowser.bat build/win/i2pbrowser.bat

build/win/i2pconfig.bat: build/win/common.bat build/win/copy-config-profile.bat build/win/copy-profile.bat build/win/launchi2p.bat
	cp src/win/i2pconfig.bat build/win/i2pconfig.bat

build/win/i2pbrowser-private.bat: build/win/common.bat build/win/copy-config-profile.bat build/win/copy-profile.bat build/win/launchi2p.bat
	cp src/win/i2pbrowser-private.bat build/win/i2pbrowser-private.bat

launchers: build/win build/win/i2pbrowser.bat build/win/i2pbrowser-private.bat build/win/i2pconfig.bat

build/app-profile/chrome: build/app-profile
	mkdir -p build/app-profile/chrome
	
build/app-profile/extensions: build/app-profile
	mkdir -p build/app-profile/extensions

build/app-profile: build
	mkdir -p build/app-profile