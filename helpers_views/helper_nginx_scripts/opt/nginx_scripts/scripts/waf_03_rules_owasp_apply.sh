#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $(readlink -m $0))/../lib/ngx-script-lib.sh"

# ------------------------------------
# Only install when you choose to install "OWASP" rules
# ------------------------------------
[[ "${PARAM_WAF_RULES}" != "OWASP" ]] && eval "${SKIP_SCRIPT}"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version
# PARAM_OWASP_CRS_VER : defined in cfg file

# Check app version
check_app "owasp-crs" "${PARAM_OWASP_CRS_VER}"
check_app "owasp-crs-azure" "${PARAM_OWASP_CRS_VER_AZURE_IDS}"
check_app_run  # Comment this line, to avoid check app version , always execute this script

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo " ------------------------------------"
echo " Install OWASP Rules - CRS...."
echo " ------------------------------------"

# Install SpiderLabs/owasp-modsecurity-crs....
# OWASP CRS info
OWASP_CRS_URL="https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/${PARAM_OWASP_CRS_VER}.tar.gz"
OWASP_CRS_PATH="${THIS_PATH_TMP}/owasp-modsecurity-crs-*/rules"
OWASP_CRS_SETUP="${THIS_PATH_TMP}/owasp-modsecurity-crs-*/crs-setup.conf.example"

# Start to setup owasp rules
wget $OWASP_CRS_URL -O - | tar -xz

IF_RULES_DOWNLOADED="$(ls ${OWASP_CRS_PATH} | grep '\.conf')"
if [[ -n "${IF_RULES_DOWNLOADED}" ]]; then
  echo 
  echo ">>>>>>>>>>>>>>>"
  echo "SAFE_DELETE \"${PARAM_OWASP_RULES_PATH}/*\" ....!"
  echo 
  SAFE_DELETE "${PARAM_OWASP_RULES_PATH}/*"

  echo 
  echo ">>>>>>>>>>>>>>>"
  echo "Copy owasp-modsecurity-crs-*/rules/* ---> ${PARAM_OWASP_RULES_PATH}/ ....!"
  echo 
  \cp -f ${OWASP_CRS_PATH}/* ${PARAM_OWASP_RULES_PATH}/

  if [[ "${PARAM_OWASP_CRS_VER_AZURE_IDS}" != "disable" ]]; then
     ls ${PARAM_OWASP_RULES_PATH}/*.conf | grep -vE "${PARAM_OWASP_CRS_VER_AZURE_IDS}" | xargs -i bash -c "echo --- {} to {}.bak (base on azure)---; mv {} {}.bak"
  fi

  # Make sure ${OWASP_CRS_SETUP} exists, and not a empty file
  if [ -s ${OWASP_CRS_SETUP} ]; then
    echo 
    echo ">>>>>>>>>>>>>>>"
    echo "cat owasp-modsecurity-crs-*/crs-setup.conf.example > ${PARAM_OWASP_RULES_PATH}/../crs-setup.conf ....!"
    echo 
    cat ${OWASP_CRS_SETUP} > ${PARAM_OWASP_RULES_PATH}/../crs-setup.conf
  fi
fi

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
