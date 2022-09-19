#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f config_overide.sh ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

. "$HOME/github-release-config.sh"

if [ -f ./i2pversion_override ]; then
  . ./i2pversion_override
fi

TODAYSDATE=$(date +%Y%m%d)

if [ -z "$DESCRIPTION" ]; then
DESCRIPTION="Daily unsigned build of i2p.firefox for $TODAYSDATE
===================================================

These builds are automatically built on a daily basis and may have serious bugs.
They are intended for testing purposes only, use them at your own risk.
"
fi

echo github-release edit -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
github-release edit -p -u "$GITHUB_USERNAME" -r "i2p.firefox" -n "$TODAYSDATE" -d "$DESCRIPTION" -t "$TODAYSDATE"
