#! /usr/bin/env bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR" || exit 1

./clean.sh
wsl make distclean
wsl make clean-extensions
wsl make extensions
./build.sh
wsl make