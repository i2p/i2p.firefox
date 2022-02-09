
UBlockOrigin.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3892224/"`./amo-version.sh ublock-origin`"/uBlock0@raymondhill.net.xpi" > UBlockOrigin.url

JShelter.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3903890/"`./amo-version.sh javascript-restrictor`"/jsr@javascriptrestrictor.xpi" > JShelter.url

onioncontainer.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3901315/"`./amo-version.sh onion-in-container-browsing`"/onioncbt@eyedeekay.github.io.xpi" > onioncontainer.url

LocalCDN.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3902456/"`./amo-version.sh localcdn-fork-of-decentraleyes`"/{b86e4813-687a-43e6-ab65-0bde4ab75758}.xpi" > LocalCDN.url

new-extensions: UBlockOrigin.url JShelter.url onioncontainer.url LocalCDN.url