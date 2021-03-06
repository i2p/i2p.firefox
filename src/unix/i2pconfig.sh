#! /usr/bin/env sh

if [ -f "/etc/i2pbrowser/i2pbrowserrc" ]; then
  . /etc/i2pbrowser/i2pbrowserrc
fi

if [ -z $CONFIGURING_PROFILE ]; then
  CONFIGURING_PROFILE="."
fi

if [ ! -d "$CONFIGURING_PROFILE" ]; then
  mkdir -p "$CONFIGURING_PROFILE" 
  cp -vr /var/lib/i2pbrowser/app-profile/* "$CONFIGURING_PROFILE" 
fi

if [ ! -f "$CONFIGURING_PROFILE/user.js" ]; then
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

$FIREFOX --profile "$CONFIGURING_PROFILE" "$ROUTER_CONSOLE" $@
