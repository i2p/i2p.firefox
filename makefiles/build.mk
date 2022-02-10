build/profile/extensions: build/profile
	mkdir -p build/profile/extensions

build/profile: build
	mkdir -p build/profile

build/win:
	mkdir -p build/win/

build/win/i2pbrowser.bat:
	cp src/win/i2pbrowser.bat build/win/i2pbrowser.bat

build/win/i2pconfig.bat:
	cp src/win/i2pconfig.bat build/win/i2pconfig.bat

build/win/i2pbrowser-private.bat:
	cp src/win/i2pbrowser-private.bat build/win/i2pbrowser-private.bat

launchers: build/win build/win/i2pbrowser.bat build/win/i2pbrowser-private.bat build/win/i2pconfig.bat

build/app-profile/chrome: build/app-profile
	mkdir -p build/app-profile/chrome
	
build/app-profile/extensions: build/app-profile
	mkdir -p build/app-profile/extensions

build/app-profile: build
	mkdir -p build/app-profile