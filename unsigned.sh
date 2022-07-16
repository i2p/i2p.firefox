#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit 1

./clean.sh
wsl make distclean
wsl make clean-extensions
wsl make extensions
./build.sh
wsl make