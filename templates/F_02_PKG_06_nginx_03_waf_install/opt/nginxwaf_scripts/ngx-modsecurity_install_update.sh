#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/lib/ngx-script-lib.sh"

start_script
# ------------------------------------
# Start
# ------------------------------------
# Install libmodsecurity (ModSecurity for Nginx)
yum install -y libmodsecurity*

# Install SpiderLabs/ModSecurity-nginx....
# Nginx info
NGX_VER="$(nginx -v 2>&1 |cut -d '/' -f2)"
NGX_SRC_URL="http://nginx.org/download/nginx-${NGX_VER}.tar.gz"
NGX_SRC_PATH="${THIS_PATH_TMP}/nginx-${NGX_VER}"

# Nginx modsecurity info
NGX_MOD_VER="$(curl -s "https://github.com/SpiderLabs/ModSecurity-nginx/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')"
NGX_MOD_URL="https://github.com/SpiderLabs/ModSecurity-nginx/releases/download/${NGX_MOD_VER}/modsecurity-nginx-${NGX_MOD_VER}.tar.gz"

# Start to compile modules/ngx_http_modsecurity_module.so
wget $NGX_MOD_URL -O - | tar -xz
wget $NGX_SRC_URL -O - | tar -xz

# compile
cd ${NGX_SRC_PATH}
./configure --with-compat --add-dynamic-module=../modsecurity-nginx-${NGX_MOD_VER}
make modules

echo 
echo ">>>>>>>>>>>>>>>"
echo "Copy objs/ngx_http_modsecurity_module.so ---> /etc/nginx/modules ....!"
echo 
\cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

echo "Done ...!"
echo 


# ------------------------------------
# Stop
# ------------------------------------
stop_script
