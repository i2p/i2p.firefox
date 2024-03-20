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
echo "$CONTENT_HERE" > news-content.html
unset CONTENT_HERE
./create_new_entry.sh

export DATE=$(date +%Y-%m-%d)
echo "$DATE"
MAGNET=$(transmission-show -m "$SCRIPT_DIR/i2pwinupdate.su3.torrent" 2>&1 3>&1 | tail -n 1)

TORRENTJSON='['
TORRENTJSON+='  {'
TORRENTJSON+="    \"date\": \"$DATE\","
TORRENTJSON+="    \"version\": \"$I2P_VERSION\","
TORRENTJSON+="    \"minVersion\": \"1.5.0\","
TORRENTJSON+="    \"minJavaVersion\": \"1.8\","
TORRENTJSON+="    \"updates\": {"
TORRENTJSON+="      \"su3\": {"
TORRENTJSON+="        \"torrent\": \"$MAGNET\","
TORRENTJSON+="        \"url\": ["
TORRENTJSON+="          \"http://ekm3fu6fr5pxudhwjmdiea5dovc3jdi66hjgop4c7z7dfaw7spca.b32.i2p/i2pwinupdate.su3\""
TORRENTJSON+='        ]'
TORRENTJSON+='      }'
TORRENTJSON+='    }'
TORRENTJSON+='  }'
TORRENTJSON+=']'

echo "$TORRENTJSON" | jq > "$I2P_NEWSXML/data/win/beta/releases.json"
echo "$TORRENTJSON" | jq > "$I2P_NEWSXML/data/win/testing/releases.json"