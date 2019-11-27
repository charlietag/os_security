#!/bin/bash
display_check_name() {
  echo ""
  echo ""
  echo "---------------------------------------------------------------------"
  echo "${BASH_SOURCE[0]}"
  echo "---------------------------------------------------------------------"
}

THIS_DIR="$(dirname $(readlink -m $0))"
CHECK_SCRIPTS_DIR="${THIS_DIR}/scripts"

cd ${CHECK_SCRIPTS_DIR}

for check_script in `ls check_*.sh`
do
  . ${CHECK_SCRIPTS_DIR}/${check_script}
  FUNC_NAME="$(basename ${check_script} | sed 's/.sh//g')"
  ${FUNC_NAME}
done
