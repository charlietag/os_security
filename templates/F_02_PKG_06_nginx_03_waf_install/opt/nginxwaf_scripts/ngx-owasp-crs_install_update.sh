#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/lib/ngx-script-lib.sh"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version
OWASP_CRS_VER="$(curl -s "https://github.com/SpiderLabs/owasp-modsecurity-crs/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')"

# Check app version
check_app "owasp-crs" "${OWASP_CRS_VER}"
check_app_done

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------

# Install SpiderLabs/owasp-modsecurity-crs....
# OWASP CRS info
#OWASP_CRS_VER="$(curl -s "https://github.com/SpiderLabs/owasp-modsecurity-crs/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')"
OWASP_CRS_URL="https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/${OWASP_CRS_VER}.tar.gz"
OWASP_CRS_PATH="${THIS_PATH_TMP}/owasp-modsecurity-crs-*/rules"

# Start to setup owasp rules
wget $OWASP_CRS_URL -O - | tar -xz

echo 
echo ">>>>>>>>>>>>>>>"
echo "rm -f /etc/nginx/server_features/NGINX-WAF/waf_conf/rules/* ....!"
echo 
rm -f /etc/nginx/server_features/NGINX-WAF/waf_conf/rules/*

echo 
echo ">>>>>>>>>>>>>>>"
echo "Copy owasp-modsecurity-crs-*/rules/* ---> /etc/nginx/server_features/NGINX-WAF/waf_conf/rules ....!"
echo 
\cp -f ${OWASP_CRS_PATH}/* /etc/nginx/server_features/NGINX-WAF/waf_conf/rules/

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
