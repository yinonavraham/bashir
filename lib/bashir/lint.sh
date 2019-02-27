#!/usr/bin/env bash

bashirImport "bashir/string_util.sh"
bashirImport "bashir/os_util.sh"

function __shellcheckDocker {
  docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable "$1"
}

function __shellcheckAppendIfFailed {
  local script="$1"
  local origFailedScripts="$2"
  local failedScripts="${origFailedScripts}"
  local scriptDir
  local scriptFile
  scriptDir="$(dirname "${script}")"
  scriptFile="$(basename "${script}")"

  echo "LINT: ${script}" >&2
  (
    cd "${scriptDir}" || exit
    __shellcheckDocker "${scriptFile}" >&2 || failedScripts="$(bashir_str_appendDelimited "$failedScripts" ", " "${script}")"
    [[ "${failedScripts}" == "${origFailedScripts}" ]] && echo "PASS: ${script}" >&2 || echo "FAIL: ${script}" >&2
    echo "${failedScripts}"
  )
}

function __shellcheckFilesInPath {
  local path="$1"
  local orig="${2-}"
  local recursive="${3-false}"
  local failedScripts="${orig}"
  for f in "${path}"/*; do
    if [[ -f "${f}" ]] && [[ "${f}" == *".sh" ]]; then
      failedScripts=$(__shellcheckAppendIfFailed "${f}" "${failedScripts}")
    elif [[ "${recursive}" == true ]] &&  [[ -d "${f}" ]]; then
      failedScripts="$(__shellcheckFilesInPath "${f}" "${failedScripts}" "${recursive}")"
    fi
  done
  echo "${failedScripts}"
}

function bashir_lint_project {
  bashir_os_ensureCommandInstalled docker
  local projDir="$1"
  local failedScripts=''

  failedScripts="$(__shellcheckFilesInPath "${projDir}")"
  failedScripts="$(__shellcheckFilesInPath "${projDir}/lib" "${failedScripts}" "true")"

  if [[ -n "${failedScripts}" ]]; then
    echo "${failedScripts}"
    return 1
  fi
  return 0
}