#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $(readlink -m $0))/../lib/ngx-script-lib.sh"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version --- defined in cfg file

# Check app version
check_app "nginx" "${PARAM_NGX_VER}"
check_app "headers-more-nginx-module" "${PARAM_NGX_HEADERS_MORE_VER}"
check_app_run
# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo " ------------------------------------"
echo " Install headers-more-nginx-module...."
echo " ------------------------------------"
stop_script
exit
# Nginx info
#PARAM_NGX_VER # var defined above
NGX_SRC_URL="http://nginx.org/download/nginx-${PARAM_NGX_VER}.tar.gz"
NGX_SRC_PATH="${THIS_PATH_TMP}/nginx-${PARAM_NGX_VER}"

# Nginx headers_more module info
#PARAM_NGX_HEADERS_MORE_VER # var defined above
NGX_HEADERS_URL="https://github.com/openresty/headers-more-nginx-module/archive/${PARAM_NGX_HEADERS_MORE_VER}.tar.gz"

# Start to compile modules/ngx_http_modsecurity_module.so
wget $NGX_SRC_URL -O - | tar -xz
wget $NGX_HEADERS_URL -O - | tar -xz

# compile
cd ${NGX_SRC_PATH}

./configure --with-compat --add-dynamic-module=../headers-more-nginx-module-${PARAM_NGX_HEADERS_MORE_VER/v}
make modules
echo 
echo ">>>>>>>>>>>>>>>"
echo "Copy objs/ngx_http_headers_more_filter_module.so ---> /etc/nginx/modules ....!"
echo 
\cp -f objs/ngx_http_headers_more_filter_module.so /etc/nginx/modules

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
