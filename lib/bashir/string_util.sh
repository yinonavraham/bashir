#!/usr/bin/env bash

function bashir_str_appendDelimited {
  local original="$1"
  local delimiter="$2"
  local suffix="$3"
  if [[ -z "${original}" ]]; then
    echo "${suffix}"
  else
    echo "${original}${delimiter}${suffix}"
  fi
}