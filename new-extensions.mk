
UBlockOrigin.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3892224/"`./amo-version.sh ublock-origin`"/uBlock0@raymondhill.net.xpi" > UBlockOrigin.url

JShelter.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3903890/"`./amo-version.sh javascript-restrictor`"/jsr@javascriptrestrictor.xpi" > JShelter.url

onioncontainer.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3901315/"`./amo-version.sh onion-in-container-browsing`"/onioncbt@eyedeekay.github.io.xpi" > onioncontainer.url

