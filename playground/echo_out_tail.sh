# Bashir: echo out using tail

set -e

BASHIR_OUT_TAIL_PID=
BASHIR_OUT_FILE=out.txt
BASHIR_OUT_ENABLED=${BASHIR_OUT_ENABLED:-true}

function finalize {
  if [[ ${BASHIR_OUT_ENABLED} == true ]]; then
    sleep 0.1 # Give the output an option to be printed out
    cleanup &
  fi
}

function cleanup {
  sleep 0.1 # Killing the tail process needs to happen after the main process stops, otherwise there is a message printed
  if [[ -n $BASHIR_OUT_TAIL_PID ]]; then
    kill $BASHIR_OUT_TAIL_PID
  fi
  if [[ -f "${BASHIR_OUT_FILE}" ]]; then
    rm "${BASHIR_OUT_FILE}"
  fi
}
trap finalize EXIT

function bashir_start_out_tail {
  if [[ ${BASHIR_OUT_ENABLED} == true ]]; then
    touch "${BASHIR_OUT_FILE}"
    tail -f "${BASHIR_OUT_FILE}" &
    BASHIR_OUT_TAIL_PID=$!
  fi
}

function bashir_echo_out {
  if [[ ${BASHIR_OUT_ENABLED} == true ]]; then
    echo "$1" >> "${BASHIR_OUT_FILE}"
  fi
}

bashir_start_out_tail


#################################

bashir_echo_out foo
bashir_echo_out bar