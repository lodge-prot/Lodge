#!/bin/bash

################################################################
#                                                              #
# FileName: test_script.sh                                     #
# Discription:                                                 #
#    Execute test                                              #
#                                                              #
################################################################

# Valiable
# =========================================

CONFIG_FILE="../test/test_script.conf"

# Files check
# =========================================

if [[ ! -f ${CONFIG_FILE} ]]; then
  echo "[ERROR] Not exist file. Pash: ${CONFIG_FILE}"
fi

# Load config file
# =========================================

source ${CONFIG_FILE}
PYTHON_PATH=$( which python3.6 )

TEST_CONF_FILE="${TEST_CONF_PATH}/$( ls -rt ${TEST_CONF_PATH} | tail -1 )"

# Parse test name from json config
# =========================================



# Function
# =========================================

function generatei_json_config(){
  GEN_CONF_CMD=$( "${PYTHON_PATH}" "${JSON_GEN_PATH}" )

  eval "${GEN_CONF_CMD}"
  local RC=$?

  if [[ "${RC}" -ne 0 ]]; then
    echo "[ERROR] Failed to execute command. Execute command: ${GEN_CONF_CMD}"
  fi

}

function perse_config_name(){
  NAME_PER_CMD=$( cat << EOS
"${PYTHON_PATH}" "${JSON_PAR_PATH}" \
--config ${TEST_CONF_FILE} \
--mode name-list
EOS
)

  eval "${NAME_PER_CMD}"
  local RC=$?

  if [[ "${RC}" -ne 0 ]]; then
    echo "[ERROR] Failed to execute command. Execute command: ${NAME_PER_CMD}"
    exit 1
  fi

}

function perse_json_config(){
  PER_CONF_CMD=$( cat << EOS
"${PYTHON_PATH}" "${JSON_PAR_PATH}" \
--config ${1} \
--mode parse \
--parse ${2}
EOS
)

  eval "${PER_CONF_CMD}"
  local RC=$?

  if [[ "${RC}" -ne 0 ]]; then
    echo "[ERROR] Failed to execute command. Execute command: ${PER_CONF_CMD}"
    exit 1
  fi

}


function code_check(){
  CCS_CMD=$( cat << EOS
${CCS_FILE_PATH} \
--src-code "${PY_CODE_PATH}/${1}" \
--problem "${PROB_PATH}/${2}" \
--answer "${ANS_PATH}/${2}"
EOS
)

  eval "${CCS_CMD}"
  local RC=$?

  if [[ "${RC}" -ne 0 ]]; then
    echo "[ERROR] Failed to execute command. Execute command: ${CCS_CMD}"
    exit 1
  fi

}

# MAIN
# =========================================

# ToDo: config file name check

TEST_LIST=$( eval perse_config_name "${TEST_CONF_FILE}" )

while read TEST_NAME; do
  ANS_PROB_FILE_NAME_LIST="$( perse_json_config "${TEST_CONF_FILE}" ${TEST_NAME} )"

  while read ANS_PROB_FILE_NAME; do
    #ToDo: File type check
    # Get Prefix
    PREFIX="$(echo ${ANS_PROB_FILE_NAME} | awk -F'_' '{ print $2 }' )"
    code_check "${TEST_NAME}_${PREFIX}.py" "${TEST_NAME}/${ANS_PROB_FILE_NAME}"
  done << EOS
${ANS_PROB_FILE_NAME_LIST}
EOS

done << EOS
${TEST_LIST}
EOS

exit 0
