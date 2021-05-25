#! /usr/bin/env sh

if [ -f "/etc/i2pbrowser/i2pbrowserrc" ]; then
  . /etc/i2pbrowser/i2pbrowserrc
fi

if [ ! -z $I2PROUTER ]; then
  echo "$I2PROUTER" "$I2PCOMMAND"
  http_proxy=http://127.0.0.1:4444 curl http://proxy.i2p || "$I2PROUTER" "$I2PCOMMAND"
else if [ -d "I2P/bin" ]; then
  http_proxy=http://127.0.0.1:4444 curl http://proxy.i2p || ./I2P/bin/I2P; \
  echo "running the jpackaged I2P router since we can't find another one to use."
fi

if [ -z $BROWSING_PROFILE ]; then
  BROWSING_PROFILE="."
fi

if [ ! -d "$BROWSING_PROFILE" ]; then
  mkdir -p "$BROWSING_PROFILE" 
  cp -vr /var/lib/i2pbrowser/profile/* "$BROWSING_PROFILE" 
fi

if [ ! -f "$BROWSING_PROFILE/user.js" ]; then
  echo "user.js not present in $BROWSING_PROFILE, this is not a Firefox profile"
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

$FIREFOX --profile "$BROWSING_PROFILE" $@
