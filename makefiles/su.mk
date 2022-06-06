GOPATH=$(HOME)/go

$(GOPATH)/src/i2pgit.org/idk/su3-tools/su3-tools:
	git clone https://i2pgit.org/idk/su3-tools $(GOPATH)/src/i2pgit.org/idk/su3-tools; true
	git pull --all
	cd $(GOPATH)/src/i2pgit.org/idk/su3-tools && \
		go mod vendor && go build

prepupdate:
	cp -v "I2P-Profile-Installer-$(PROFILE_VERSION)-signed.su3" i2pwinupdate.su3

su3: $(GOPATH)/src/i2pgit.org/idk/su3-tools/su3-tools
	$(GOPATH)/src/i2pgit.org/idk/su3-tools/su3-tools -name "I2P-Profile-Installer-$(PROFILE_VERSION)-signed" -signer "$(SIGNER)" -version "$(I2P_VERSION)"
	java -cp "$(HOME)/i2p/lib/*" net.i2p.crypto.SU3File sign -c ROUTER -f EXE I2P-Profile-Installer-$(PROFILE_VERSION)-signed.exe I2P-Profile-Installer-$(PROFILE_VERSION)-signed.su3 "$(HOME)/.i2p-plugin-keys/news-su3-keystore.ks" $(PROFILE_VERSION) $(SIGNER)

i2pwinupdate.su3.torrent: prepupdate su3
	mktorrent \
		--announce=http://tracker2.postman.i2p/announce.php \
		--announce=http://w7tpbzncbcocrqtwwm3nezhnnsw4ozadvi2hmvzdhrqzfxfum7wa.b32.i2p/a \
		--announce=http://mb5ir7klpc2tj6ha3xhmrs3mseqvanauciuoiamx2mmzujvg67uq.b32.i2p/a \
		i2pwinupdate.su3

torrent: i2pwinupdate.su3.torrent

releases.json:
	@echo "["		| tee ../i2p.newsxml/data/win/beta/releases.json
	@echo "  {"		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    \"date\": \"$(I2P_DATE)\","			| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    \"version\": \"$(PROFILE_VERSION)\","	| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    \"minVersion\": \"1.5.0\","			| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    \"minJavaVersion\": \"1.8\","		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    \"updates\": {"		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "      \"su3\": {"		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "        \"torrent\": \"$(MAGNET)\","		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "        \"url\": ["		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "          \"http://ekm3fu6fr5pxudhwjmdiea5dovc3jdi66hjgop4c7z7dfaw7spca.b32.i2p/i2pwinupdate.su3\""	| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "        ]"	| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "      }"		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "    }"		| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "  }"			| tee -a ../i2p.newsxml/data/win/beta/releases.json
	@echo "]"			| tee -a ../i2p.newsxml/data/win/beta/releases.json
