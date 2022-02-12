
build-new-extensions: build/i2ppb@eyedeekay.github.io.xpi build/uBlock0@raymondhill.net.xpi build/jsr@javascriptrestrictor.xpi build/onioncbt@eyedeekay.github.io.xpi build/{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi

build/uBlock0@raymondhill.net.xpi:
	curl -L `cat UblockOrigin.url` > build/uBlock0@raymondhill.net.xpi

build/jsr@javascriptrestrictor.xpi:
	curl -L `cat JShelter.url` > build/jsr@javascriptrestrictor.xpi

build/onioncbt@eyedeekay.github.io.xpi:
	curl -L `cat onioncontainer.url` > build/onioncbt@eyedeekay.github.io.xpi

build/{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi:
	curl -L `cat LocalCDN.url` > build//{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi

UBlockOrigin.url:
	@echo `./amo-version.sh ublock-origin` > UBlockOrigin.url

JShelter.url:
	@echo "`./amo-version.sh javascript-restrictor`" > JShelter.url

onioncontainer.url:
	@echo `./amo-version.sh onion-in-container-browsing` > onioncontainer.url

LocalCDN.url:
	@echo `./amo-version.sh localcdn-fork-of-decentraleyes` > LocalCDN.url

clean-new-extensions:
	rm -f UBlockOrigin.url JShelter.url onioncontainer.url LocalCDN.url build/i2ppb@eyedeekay.github.io.xpi build/onioncbt@eyedeekay.github.io.xpi

new-extensions: UBlockOrigin.url JShelter.url onioncontainer.url LocalCDN.url