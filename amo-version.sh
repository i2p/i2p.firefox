#! /usr/bin/env sh

curl -s https://addons.mozilla.org/api/v5/addons/addon/$1/versions/?page_size=1 | jq '.results | .[0] | .version' | tr -d '"'