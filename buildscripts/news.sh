#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)/..
cd "$SCRIPT_DIR" || exit 1

. "$SCRIPT_DIR/i2pversion"

if [ -f i2pversion_override ]; then
    . "$SCRIPT_DIR/i2pversion_override"
fi

. "$SCRIPT_DIR/config.sh"

if [ -f "$SCRIPT_DIR/config_override.sh" ]; then
  . "$SCRIPT_DIR/config_override.sh"
fi

if [ -z "$I2P_NEWSXML" ]; then
    if [ -d "../i2p.newsxml" ]; then
        export I2P_NEWSXML="../i2p.newsxml"
    else 
        echo "i2p.newsxml is not in the parent directory and I2P_NEWSXML is unset"
        exit 1
    fi
fi

cd "$I2P_NEWSXML" || exit 1 
export TITLE="Easy-Install for Windows Release $I2P_VERSION"
echo "$TITLE"
export AUTHOR=idk
echo "$AUTHOR"
export EDITOR=true
echo "canceled manual editor"
export I2P_OS=win
echo "$I2P_OS"
export I2P_BRANCH=beta
echo "$I2P_VERSION"
export SUMMARY_HERE=$(head -n 1 "$SCRIPT_DIR/docs/RELEASE.md" | sed "s|# ||g")
echo "$SUMMARY_HERE"
export CONTENT_HERE=$(tail -n +2 "$SCRIPT_DIR/docs/RELEASE.md" | markdown)
echo "$CONTENT_HERE"
./create_new_entry.sh