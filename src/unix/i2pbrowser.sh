#! /usr/bin/env sh

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

$FIREFOX --profile . $@
