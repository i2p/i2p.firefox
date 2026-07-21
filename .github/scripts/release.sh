#!/usr/bin/env bash

set -euo pipefail

mode="${1:-prepare}"

case "$mode" in
  wait)
    wait_minutes="${WAIT_MINUTES:-20}"
    for ((remaining=wait_minutes; remaining > 0; remaining--)); do
      echo "sleeping ${remaining} minute(s) to wait for build artifacts"
      sleep 1m
    done
    ;;

  prepare)
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
    ;;

  *)
    echo "usage: $0 [wait|prepare]" >&2
    exit 2
    ;;
esac
