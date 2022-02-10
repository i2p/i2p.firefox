orig:
	tar --exclude=debian --exclude=.git -cvzf ../i2p-firefox-profile_$(PROFILE_VERSION).orig.tar.gz .

## HOWTO: If you need to release a package to launchpad, build for the oldest
## release launchpad supports(bionic AFIACT). Then, after the build is
## published, copy it to the other distributions. When bionic is out of date,
## update it to the new LTS.

bionic:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) bionic; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

focal:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) focal; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

groovy:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) groovy; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

buster:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) buster; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

bullseye:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) bullseye; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

trixie:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) trixie; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

sid:
	@sed -i "s|`head -n 1 debian/changelog`|i2p-firefox-profile ($(PROFILE_VERSION)-1) sid; urgency=medium|g" debian/changelog
	make orig
	debuild -S
	make dput

dput:
	dput --simulate --force ppa:i2p-community/ppa ../i2p-firefox-profile_$(PROFILE_VERSION)-1_source.changes || exit
	dput --force ppa:i2p-community/ppa ../i2p-firefox-profile_$(PROFILE_VERSION)-1_source.changes

launchpad: bionic