#!/usr/bin/env bash

function bashir_os_ensureCommandInstalled {
  if ! command -v "$1" > /dev/null; then
    echo "ERROR: Not installed (at least not in PATH): $1"
    exit 1
  fi
}