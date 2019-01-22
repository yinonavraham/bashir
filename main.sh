#!/usr/bin/env bash

bashirImport "bashir/lint.sh"

function __bashir_lint {
  local out
  if ! out="$(bashir_lint_project "${BASHIR_WORK_DIR}")"; then
    if [[ "${out}" == "ERROR:"* ]]; then
      echo "${out}"
    else
      echo "The following scripts have lint errors: ${out}"
      echo "Overall LINT result: FAIL"
    fi
    exit 1
  fi
  echo "Overall LINT result: PASS"
}

function __bashir_help {
  cat <<EOF

Bashir - bash tooling framework and dependency management tool
  Usage: ${BASHIR_SCRIPT_NAME} [OPTIONS] <COMMAND> [ARGUMENTS]...

Commands:
  lint  Lint the current project.
        Runs ShellCheck on all .sh script files in the project\'s root directory
        and the lib directory recursively.

Options:
  -h,--help  Show this help usage

EOF
}

function main {
  case "${1-}" in
    lint)
      __bashir_lint
      ;;
    -h|--help)
      __bashir_help
      ;;
    *)
      bashirExitWithError "Unexpected syntax, use --help for usage details"
      ;;
  esac
}