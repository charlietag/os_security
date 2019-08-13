#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/../lib/ngx-script-lib.sh"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version --- defined in cfg file
# PARAM_MODSEC_VER : 
# current libmodsecurity.so version (readlink  /usr/local/modsecurity/lib/libmodsecurity.so)

# Check app version
check_app "nginx" "${PARAM_NGX_VER}"
check_app "ModSecurity-nginx" "${PARAM_NGX_MOD_VER}"
check_app "libmodsecurity" "${PARAM_MODSEC_VER}"
check_app_run

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo " ------------------------------------"
echo " Install SpiderLabs/ModSecurity-nginx.... (modsecurity-nginx-connector)"
echo " ------------------------------------"
# Nginx info
#PARAM_NGX_VER="$(nginx -v 2>&1 |cut -d '/' -f2)" # defined above
NGX_SRC_URL="http://nginx.org/download/nginx-${PARAM_NGX_VER}.tar.gz"
NGX_SRC_PATH="${THIS_PATH_TMP}/nginx-${PARAM_NGX_VER}"

# Nginx modsecurity info
#PARAM_NGX_MOD_VER # var defined above
NGX_MOD_URL="https://github.com/SpiderLabs/ModSecurity-nginx/releases/download/${PARAM_NGX_MOD_VER}/modsecurity-nginx-${PARAM_NGX_MOD_VER}.tar.gz"

# Start to compile modules/ngx_http_modsecurity_module.so
wget $NGX_MOD_URL -O - | tar -xz
wget $NGX_SRC_URL -O - | tar -xz

# compile
cd ${NGX_SRC_PATH}

sed -i 's/NGX_LOG_WARN/NGX_LOG_ERR/g' ../modsecurity-nginx-${PARAM_NGX_MOD_VER}/src/ngx_http_modsecurity_module.c  # make sure modsecurity writes log into nginx "error" log, instead of using nginx error_log path warn;

./configure --with-compat --add-dynamic-module=../modsecurity-nginx-${PARAM_NGX_MOD_VER}
make modules

echo 
echo ">>>>>>>>>>>>>>>"
echo "Copy objs/ngx_http_modsecurity_module.so ---> /etc/nginx/modules ....!"
echo 
\cp -f objs/ngx_http_modsecurity_module.so /etc/nginx/modules

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
