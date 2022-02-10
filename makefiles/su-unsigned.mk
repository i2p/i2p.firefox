
prepupdate-unsignedexe:
	cp -v "I2P-Profile-Installer-$(PROFILE_VERSION).su3" i2pwinupdate-unsignedexe.su3

su3-unsignedexe: $(GOPATH)/src/i2pgit.org/idk/su3-tools/su3-tools
	$(GOPATH)/src/i2pgit.org/idk/su3-tools/su3-tools -name "I2P-Profile-Installer-$(PROFILE_VERSION)" -signer "$(SIGNER)" -version "$(I2P_VERSION)"
	java -cp "$(HOME)/i2p/lib/*" net.i2p.crypto.SU3File sign -c ROUTER -f EXE I2P-Profile-Installer-$(PROFILE_VERSION).exe I2P-Profile-Installer-$(PROFILE_VERSION)-signed.su3 "$(HOME)/.i2p-plugin-keys/news-su3-keystore.ks" "$(I2P_VERSION)" $(SIGNER)

i2pwinupdate-unsignedexe.su3.torrent: prepupdate-unsignedexe su3-unsignedexe
	mktorrent \
		--announce=http://tracker2.postman.i2p/announce.php \
		--announce=http://w7tpbzncbcocrqtwwm3nezhnnsw4ozadvi2hmvzdhrqzfxfum7wa.b32.i2p/a \
		--announce=http://mb5ir7klpc2tj6ha3xhmrs3mseqvanauciuoiamx2mmzujvg67uq.b32.i2p/a \
		i2pwinupdate-unsignedexe.su3

torrent-unsignedexe: i2pwinupdate-unsignedexe.su3.torrent

testing-releases.json: torrent-unsignedexe
	mkdir -p ../i2p.newsxml/data/win/testing/
	@echo "["		| tee ../i2p.newsxml/data/win/testing/releases.json
	@echo "  {"		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    \"date\": \"$(I2P_DATE)\","			| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    \"version\": \"$(I2P_VERSION)\","	| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    \"minVersion\": \"1.5.0\","			| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    \"minJavaVersion\": \"1.8\","		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    \"updates\": {"		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "      \"su3\": {"		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "        \"torrent\": \"$(MAGNET_TESTING)\","		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "        \"url\": ["		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "          \"http://ekm3fu6fr5pxudhwjmdiea5dovc3jdi66hjgop4c7z7dfaw7spca.b32.i2p/i2pwinupdate.su3\""	| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "        ]"	| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "      }"		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "    }"		| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "  }"			| tee -a ../i2p.newsxml/data/win/testing/releases.json
	@echo "]"			| tee -a ../i2p.newsxml/data/win/testing/releases.json
