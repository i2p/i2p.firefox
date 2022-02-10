
build-new-extensions: build/i2ppb@eyedeekay.github.io.xpi build/NoScript.xpi build/HTTPSEverywhere.xpi

build/uBlock0@raymondhill.net.xpi:
	curl -L `cat UblockOrigin.url` > build/uBlock0@raymondhill.net.xpi

build//jsr@javascriptrestrictor.xpi:
	curl -L `cat JShelter.url` > build/jsr@javascriptrestrictor.xpi

build/onioncbt@eyedeekay.github.io.xpi:
	curl -L `cat onioncontainer.url` > build/onioncbt@eyedeekay.github.io.xpi

build/{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi:
	curl -L `cat LocalCDN.url` > build//{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi

UBlockOrigin.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3892224/"`./amo-version.sh ublock-origin`"/uBlock0@raymondhill.net.xpi" > UBlockOrigin.url

JShelter.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3903890/"`./amo-version.sh javascript-restrictor`"/jsr@javascriptrestrictor.xpi" > JShelter.url

onioncontainer.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3901315/"`./amo-version.sh onion-in-container-browsing`"/onioncbt@eyedeekay.github.io.xpi" > onioncontainer.url

LocalCDN.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3902456/"`./amo-version.sh localcdn-fork-of-decentraleyes`"/{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi" > LocalCDN.url

clean-new-extensions:
	rm -f UBlockOrigin.url JShelter.url onioncontainer.url LocalCDN.url build/i2ppb@eyedeekay.github.io.xpi build/onioncbt@eyedeekay.github.io.xpi

new-extensions: UBlockOrigin.url JShelter.url onioncontainer.url LocalCDN.url