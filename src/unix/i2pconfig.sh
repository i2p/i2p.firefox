#! /usr/bin/env sh

if [ -f "/etc/i2pbrowser/i2pbrowserrc" ]; then
  . /etc/i2pbrowser/i2pbrowserrc
fi

if [ ! -z $I2PROUTER ]; then
  "$I2PROUTER" start
fi

if [ -f "$HOME/.i2p/router.config" ]; then
  if [ "$0" = "/usr/local/bin/i2pconfig" ]; then
    if ! grep -R 'routerconsole.browser' "$HOME/.i2p/router.config" ; then
      echo "routerconsole.browser=$0" | tee -a "$HOME/.i2p/router.config"
    fi
  fi
fi

if [ -z $CONFIGURING_PROFILE ]; then
  CONFIGURING_PROFILE="."
fi

if [ -z $ROUTER_CONSOLE ]; then
  ROUTER_CONSOLE="$1"
  if [ -z $1 ]; then
    ROUTER_CONSOLE="http://127.0.0.1:7657"
  fi
fi

if [ ! -d "$CONFIGURING_PROFILE" ]; then
  mkdir -p "$CONFIGURING_PROFILE" 
  cp -vr /var/lib/i2pbrowser/app-profile/* "$CONFIGURING_PROFILE" 
fi

if [ ! -f "$CONFIGURING_PROFILE/user.js" ]; then
  echo "user.js not present in $CONFIGURING_PROFILE, this is not a Firefox profile"
  exit 1
fi

if [ -z $FIREFOX ]; then
  if [ -f "firefox/firefox" ]; then
    FIREFOX="./firefox/firefox"
  fi
  FIREFOX=$(which firefox-esr)
  if [ -z $FIREFOX ]; then
    FIREFOX=$(which firefox)
  fi
fi

if [ -z $FIREFOX ]; then
  echo "Firefox does not appear to be in your \$PATH."
  echo "Please install Firefox via a package manager, or"
  echo "or set the FIREFOX variable in your shell to the"
  echo "location of a Firefox executable."
  exit 1
fi

echo $FIREFOX --profile "$CONFIGURING_PROFILE" "$ROUTER_CONSOLE" $@

$FIREFOX --profile "$CONFIGURING_PROFILE" "$ROUTER_CONSOLE" $@
