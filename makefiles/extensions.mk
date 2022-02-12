
build-extensions: build/i2ppb@eyedeekay.github.io.xpi build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi build/https-everywhere-eff@eff.org.xpi

build/i2ppb@eyedeekay.github.io.xpi: i2psetproxy.url
	curl -L `cat i2psetproxy.url` > build/i2ppb@eyedeekay.github.io.xpi

build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi: NoScript.url
	curl -L `cat NoScript.url` > "build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"

build/https-everywhere-eff@eff.org.xpi: HTTPSEverywhere.url
	curl -L `cat HTTPSEverywhere.url` > build/https-everywhere-eff@eff.org.xpi

clean-extensions:
	rm -fv i2psetproxy.url NoScript.url HTTPSEverywhere.url build/i2ppb@eyedeekay.github.io.xpi build/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi build/https-everywhere-eff@eff.org.xpi

extensions: HTTPSEverywhere.url NoScript.url i2psetproxy.url

HTTPSEverywhere.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3809748/"`./amo-version.sh https-everywhere`"/https-everywhere-eff@eff.org.xpi" > HTTPSEverywhere.url

NoScript.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3534184/"`./amo-version.sh noscript`"/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi" > NoScript.url

i2psetproxy.url:
	@echo "https://addons.mozilla.org/firefox/downloads/file/3887295/"`./amo-version.sh i2p-in-private-browsing`"/i2ppb@eyedeekay.github.io.xpi" > i2psetproxy.url
