#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/lib/ngx-script-lib.sh"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version
NGX_VER="$(nginx -v 2>&1 |cut -d '/' -f2)"
NGX_HEADERS_MORE_VER="$(curl -s https://github.com/openresty/headers-more-nginx-module/releases | grep -Eo "v[[:digit:]|\.]+.tar.gz" | head -n 1 | sed 's/\.tar\.gz//g')"

# Check app version
check_app "nginx" "${NGX_VER}"
check_app "headers-more-nginx-module" "${NGX_HEADERS_MORE_VER}"
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
# Nginx info
#NGX_VER # var defined above
NGX_SRC_URL="http://nginx.org/download/nginx-${NGX_VER}.tar.gz"
NGX_SRC_PATH="${THIS_PATH_TMP}/nginx-${NGX_VER}"

# Nginx headers_more module info
#NGX_HEADERS_MORE_VER # var defined above
NGX_HEADERS_URL="https://github.com/openresty/headers-more-nginx-module/archive/${NGX_HEADERS_MORE_VER}.tar.gz"

# Start to compile modules/ngx_http_modsecurity_module.so
wget $NGX_SRC_URL -O - | tar -xz
wget $NGX_HEADERS_URL -O - | tar -xz

# compile
cd ${NGX_SRC_PATH}

./configure --with-compat --add-dynamic-module=../headers-more-nginx-module-${NGX_HEADERS_MORE_VER/v}
make modules
exit
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
