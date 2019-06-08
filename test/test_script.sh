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

CONFIG_FILE="./test/test_script.conf"

# Files check
# =========================================

if [[ ! -f ${CONFIG_FILE} ]]; then
  echo "[ERROR] Not exist file. Pash: ${CONFIG_FILE}"
fi

# Load config file
# =========================================

source ${CONFIG_FILE}


# Parse test name from json config
# =========================================



# Function
# =========================================

function perse_json_config(){
  PER_CONF_CMD=$( cat << EOS
/usr/local/bin/python3.7 "${JSON_PAR_PATH}" \
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
PER_NAME_LIST_CMD=$( cat << EOS
/usr/local/bin/python3.7 "${JSON_PAR_PATH}" \
--config ${TEST_CONF_PATH}/config.json \
--mode name-list
EOS
)

TEST_LIST=$( eval "${PER_CONF_CMD}" )

for TEST_NAME in "${TEST_LIST}"; do
  ANS_PROB_FILE_NAME_LIST="$( perse_json_config ${TEST_NAME} )"

  for ANS_PROB_FILE_NAME in "${ANS_PROB_FILE_NAME_LIST}" ; do
    #ToDo: File type check
    code_check "${TEST_NAME}.py" "${ANS_PROB_FILE_NAME}"
  done

done

exit 0
