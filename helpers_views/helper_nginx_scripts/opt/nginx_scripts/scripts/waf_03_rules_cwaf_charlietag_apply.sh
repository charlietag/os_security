#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $(readlink -m $0))/../lib/ngx-script-lib.sh"

# ------------------------------------
# Only install when you choose to install "cwaf_charlietag" rules
# ------------------------------------
[[ "${PARAM_WAF_RULES}" != "cwaf_charlietag" ]] && eval "${SKIP_SCRIPT}"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version
# PARAM_CWAF_RULES_VER : defined in cfg file

# Check app version
check_app "cwaf-rules-version" "${PARAM_CWAF_RULES_VER}"
check_app_run  # Comment this line, to avoid check app version , always execute this script

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo " ------------------------------------"
echo " Install COMODO Rules - CWAF...."
echo " ------------------------------------"
# Install Comodo WAF Rules....

# Start to setup comodo rules
wget \
--content-disposition \
https://github.com/charlietag/cwaf_charlietag/raw/master/output/cwaf_rules_nginx_3-${PARAM_CWAF_RULES_VER}.tgz \
 -O - | tar -xz

IF_RULES_DOWNLOADED="$(ls ${THIS_PATH_TMP} | grep '\.conf')"
if [[ -n "${IF_RULES_DOWNLOADED}" ]]; then
  echo 
  echo ">>>>>>>>>>>>>>>"
  echo "SAFE_DELETE \"${PARAM_CWAF_CHARLIETAG_RULES_PATH}/*\" ....!"
  echo 
  SAFE_DELETE "${PARAM_CWAF_CHARLIETAG_RULES_PATH}/*"

  echo 
  echo ">>>>>>>>>>>>>>>"
  echo "Copy comodo rules ---> ${PARAM_CWAF_CHARLIETAG_RULES_PATH}/ ....!"
  cd ${PARAM_CWAF_CHARLIETAG_RULES_PATH}
  echo 
  \cp -f ${THIS_PATH_TMP}/* ${PARAM_CWAF_CHARLIETAG_RULES_PATH}/
fi

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
