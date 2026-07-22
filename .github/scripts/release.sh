#!/usr/bin/env bash

set -euo pipefail

shopt -s nullglob
archives=( *.zip )
for archive in "${archives[@]}"; do
  unzip "$archive"
  rm "$archive"
done

echo "" | tee -a changelog.txt
echo "## Checksums" | tee -a changelog.txt
echo "" | tee -a changelog.txt
echo '```' | tee -a changelog.txt
sha256sum * | tee -a changelog.txt
echo '```' | tee -a changelog.txt
echo "" | tee -a changelog.txt
echo '```' | tee -a changelog.txt
file * | tee -a changelog.txt
echo '```' | tee -a changelog.txt
echo "" | tee -a changelog.txt
cat docs/RELEASE.md changelog.txt > RELEASE.md
