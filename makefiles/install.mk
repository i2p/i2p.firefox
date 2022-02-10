install:
	install -D -m644 src/unix/i2pbrowserrc /etc/i2pbrowser/i2pbrowserrc
	install -D -m644 src/unix/i2pbrowserdebianrc /etc/i2pbrowser/i2pbrowserdebianrc
	install -D -m755 build/profile/i2pbrowser.sh /usr/local/bin/i2pbrowser
	install -D -m755 build/app-profile/i2pconfig.sh /usr/local/bin/i2pconfig
	install -D -m755 src/unix/i2p-config-service-setup.sh /usr/local/bin/i2p-config-service-setup
	cp -vr build/profile /var/lib/i2pbrowser/profile
	cp -vr build/app-profile /var/lib/i2pbrowser/app-profile
	cp -vr src/icons /var/lib/i2pbrowser/icons
	cp src/unix/desktop/i2pbrowser.desktop /usr/share/applications
	cp src/unix/desktop/i2pconfig.desktop /usr/share/applications

uninstall:
	rm -rfv /etc/i2pbrowser \
		/var/lib/i2pbrowser \
		/etc/i2pbrowser/i2pbrowserrc \
		/usr/local/bin/i2pbrowser \
		/usr/local/bin/i2pconfig \
		/usr/local/bin/i2p-config-service-setup \
		/usr/share/applications/i2pbrowser.desktop \
		/usr/share/applications/i2pconfig.desktop

checkinstall: .version
	checkinstall \
		--default \
		--install=no \
		--fstrans=yes \
		--pkgname=i2p-firefox \
		--pkgversion=$(PROFILE_VERSION) \
		--pkggroup=net \
		--pkgrelease=1 \
		--pkgsource="https://i2pgit.org/i2p-hackers/i2p.firefox" \
		--maintainer="$(SIGNER)" \
		--requires="firefox,wget" \
		--suggests="i2p,i2p-router,syndie,tor,tsocks" \
		--nodoc \
		--deldoc=yes \
		--deldesc=yes \
		--backup=no
