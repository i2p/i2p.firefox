#! /usr/bin/env sh

# Works for Debian service installs. Sets up minified, custom profile for configuring I2P console.

if grep '^i2psvc:' /etc/passwd; then
  I2P_HOME=$(grep '^i2psvc:' /etc/passwd | sed 's|i2psvc:x:||g' | sed 's|:/usr/sbin/nologin||g' | tr -d ':1234567890' | sed 's|ip|i2p|g')
  ROUTER_CONFIG=$(sudo -u i2psvc ls $I2P_HOME/i2p-config/router.config)
fi

installer(){

  if [ $(sudo -u i2psvc ls $I2P_HOME/i2p-config/router.config) ]; then
    echo $I2P_HOME $ROUTER_CONFIG $0
      if ! sudo -u i2psvc grep -R 'routerconsole.browser' "$I2P_HOME/i2p-config/router.config" ; then
        echo "routerconsole.browser=/usr/local/bin/i2pconfig" | sudo tee -a "$I2P_HOME/i2p-config/router.config"
      fi
  fi
}


installer
