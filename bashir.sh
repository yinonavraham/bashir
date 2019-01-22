#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly BASHIR_VERBOSE="${BASHIR_VERBOSE:-false}"

function bashirLogVerbose {
  if [[ "${BASHIR_VERBOSE}" == true ]]; then
    echo "$1"
  fi
}

function bashirEchoError {
  echo "$@" >&2
}

function bashirExitWithError {
  local msg="$1"
  local code="${2:-1}"
  bashirEchoError "ERROR: ${msg}"
  exit "${code}"
}

function bashirImport {
  local path="$1"
  local fullLibPath="${BASHIR_SCRIPT_INSTALL_DIR}/lib/${path}"
  local fullDepPath="${BASHIR_SCRIPT_INSTALL_DIR}/dep/${path}"
  bashirLogVerbose "Checking source file to import exists in lib: '${fullLibPath}' or dep: '${fullDepPath}'"
  if [[ -f "${fullLibPath}" ]]; then
    bashirLogVerbose "Importing source file from lib path: ${fullLibPath}"
    # shellcheck source=/dev/null
    source "${fullLibPath}"
  elif [[ -f "${fullDepPath}" ]]; then
    bashirLogVerbose "Importing source file from dep path: ${fullDepPath}"
    # shellcheck source=/dev/null
    source "${fullDepPath}"
  else
    bashirExitWithError "Import file not found: ${path}"
  fi
}

function __bashirImport {
  local path="$1"
  local fullPath="${BASHIR_SCRIPT_INSTALL_DIR}/${path}"
  bashirLogVerbose "Importing source file from path: '${fullPath}'"
  if [[ -f "${fullPath}" ]]; then
    # shellcheck source=/dev/null
    source "${fullPath}"
  else
    bashirExitWithError "Import file not found: ${fullPath}"
  fi
}

readonly BASHIR_WORK_DIR="$(pwd)"
readonly BASHIR_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly BASHIR_SCRIPT_NAME="$(basename "$0")"
readonly BASHIR_SCRIPT_PATH="${BASHIR_SCRIPT_DIR}/${BASHIR_SCRIPT_NAME}"

BASHIR_SCRIPT_INSTALL_PATH="$(readlink -n "$0" || echo '')"
if [[ -n "${BASHIR_SCRIPT_INSTALL_PATH}" ]]; then
  if [[ "${BASHIR_SCRIPT_INSTALL_PATH}" != /* ]]; then
    BASHIR_SCRIPT_INSTALL_PATH="${BASHIR_SCRIPT_DIR}/${BASHIR_SCRIPT_INSTALL_PATH}"
  fi
else
  BASHIR_SCRIPT_INSTALL_PATH="${BASHIR_SCRIPT_DIR}/${BASHIR_SCRIPT_NAME}"
fi
readonly BASHIR_SCRIPT_INSTALL_DIR="$(cd "$(dirname "${BASHIR_SCRIPT_INSTALL_PATH}")" && pwd)"
readonly BASHIR_SCRIPT_INSTALL_NAME="$(basename "${BASHIR_SCRIPT_INSTALL_PATH}")"
readonly BASHIR_SCRIPT_INSTALL_PATH="${BASHIR_SCRIPT_INSTALL_DIR}/${BASHIR_SCRIPT_INSTALL_NAME}"

bashirLogVerbose "Work Dir:            '${BASHIR_WORK_DIR}'"
bashirLogVerbose "Script Path:         '${BASHIR_SCRIPT_PATH}'"
bashirLogVerbose "Script Dir:          '${BASHIR_SCRIPT_DIR}'"
bashirLogVerbose "Script Name:         '${BASHIR_SCRIPT_NAME}'"
bashirLogVerbose "Script Install Path: '${BASHIR_SCRIPT_INSTALL_PATH}'"
bashirLogVerbose "Script Install Dir:  '${BASHIR_SCRIPT_INSTALL_DIR}'"
bashirLogVerbose "Script Install Name: '${BASHIR_SCRIPT_INSTALL_NAME}'"

if [[ -f "${BASHIR_SCRIPT_INSTALL_PATH}.env" ]]; then 
  bashirLogVerbose "Importing bashir environment from path: ${BASHIR_SCRIPT_INSTALL_PATH}.env"
  # shellcheck source=/dev/null
  source "${BASHIR_SCRIPT_INSTALL_PATH}.env"
fi

readonly BASHIR_MAIN_FILE="${BASHIR_MAIN_FILE:-main.sh}"
bashirLogVerbose "Bashir Main File: '${BASHIR_MAIN_FILE}'"
__bashirImport "${BASHIR_MAIN_FILE}"

main "$@"
