#!/bin/bash

./clean.sh
wsl make distclean
wsl make clean-extensions
wsl make extensions
./build.sh
wsl make