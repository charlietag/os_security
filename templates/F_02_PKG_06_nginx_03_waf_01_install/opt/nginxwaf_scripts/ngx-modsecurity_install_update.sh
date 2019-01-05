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
NGX_MOD_VER="$(curl -s "https://github.com/SpiderLabs/ModSecurity-nginx/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')"
# PARAM_MODSEC_VER : defined in cfg file
# current libmodsecurity.so version (readlink  /usr/local/modsecurity/lib/libmodsecurity.so)

# Check app version
check_app "nginx" "${NGX_VER}"
check_app "ModSecurity-nginx" "${NGX_MOD_VER}"
check_app "libmodsecurity" "${PARAM_MODSEC_VER}"
check_app_done

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo "------------------------------------"
echo "Remove packages which might be conflicted with manually compiled libmodsecurity"
echo "------------------------------------"
rpm --quiet -q libmodsecurity && yum remove -y libmodsecurity*

# ------------------------------------
# Install libmodsecurity (ModSecurity for Nginx)
# ------------------------------------
#yum install -y libmodsecurity*

echo " ------------------------------------"
echo " Install libmodsecurity (Manually compile libmodsecurity - Modsecurity for Nginx)"
echo " ------------------------------------"
# modsecurity info
# PARAM_MODSEC_VER : defined in cfg file
MODSEC_SRC_URL="https://github.com/SpiderLabs/ModSecurity/releases/download/${PARAM_MODSEC_VER}/modsecurity-${PARAM_MODSEC_VER}.tar.gz"
MODSEC_SRC_PATH="${THIS_PATH_TMP}/modsecurity-${PARAM_MODSEC_VER}"

# Start to compile libmodsecurity.so
# -- Latest version --
#git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity
# submodule(.gitmodules) folder contains nothing, do a submodule init / update
#git submodule init
#git submodule update
#./build.sh

# -- Fiexed version --
# submodule(.gitmodules) folder contains everything, no need to do a submodule init / update
wget $MODSEC_SRC_URL -O - | tar -xz
cd ${MODSEC_SRC_PATH}
./configure --enable-parser-generation --enable-mutex-on-pm --with-lmdb
make || { echo "FATAL: make" ; exit 1; }
make install || { echo "FATAL: make install" ; exit 1; }

cd $THIS_PATH_TMP # back to tmp folder

# ***********************************************************************************************************
echo " ------------------------------------"
echo " Install SpiderLabs/ModSecurity-nginx.... (modsecurity-nginx-connector)"
echo " ------------------------------------"
# Nginx info
#NGX_VER="$(nginx -v 2>&1 |cut -d '/' -f2)" # defined above
NGX_SRC_URL="http://nginx.org/download/nginx-${NGX_VER}.tar.gz"
NGX_SRC_PATH="${THIS_PATH_TMP}/nginx-${NGX_VER}"

# Nginx modsecurity info
#NGX_MOD_VER="$(curl -s "https://github.com/SpiderLabs/ModSecurity-nginx/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')" # defined above
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
\cp -f objs/ngx_http_modsecurity_module.so /etc/nginx/modules

echo "Done ...!"
echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
