#! /usr/bin/env sh

# Works for Debian service installs. Sets up minified, custom profile for configuring I2P console.

if grep '^i2psvc:' /etc/passwd; then
	I2P_HOME=$(grep '^i2psvc:' /etc/passwd | sed 's|i2psvc:x:||g' | sed 's|:/usr/sbin/nologin||g' | tr -d ':1234567890' | sed 's|ip|i2p|g')
	sudo -u i2psvc less $I2P_HOME/i2p-config/router.config
fi

installer(){
	if [ -f "$I2P_HOME/i2p-config/router.config" ]; then
	  if [ "$0" = "/usr/local/bin/i2pconfig" ]; then
	    if ! grep -R 'routerconsole.browser' "$I2P_HOME/i2p-config/router.config" ; then
	      echo "routerconsole.browser=$0" | tee -a "$I2P_HOME/i2p-config/router.config"
	    fi
	  fi
	fi
}