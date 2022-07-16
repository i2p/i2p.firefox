#! /usr/bin/env bash

curl -s "https://addons.mozilla.org/api/v5/addons/addon/$1/versions/?page_size=1" | jq '.results | .[0] | .file | .url' | tr -d '"'

