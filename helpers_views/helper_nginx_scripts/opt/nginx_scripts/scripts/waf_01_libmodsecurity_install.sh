#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $(readlink -m $0))/../lib/ngx-script-lib.sh"

# ------------------------------------
# Define and check app version
# ------------------------------------
# App version
# PARAM_MODSEC_VER : defined in cfg file
# current libmodsecurity.so version (readlink  /usr/local/modsecurity/lib/libmodsecurity.so)

# Check app version
check_app "libmodsecurity" "${PARAM_MODSEC_VER}"
check_app_run # Comment this line, to avoid check app version , always execute this script

# ------------------------------------

start_script
# ***********************************************************************************************************
# ------------------------------------
# Start
# ------------------------------------
echo "------------------------------------"
echo "Remove packages which might be conflicted with manually compiled libmodsecurity"
echo "------------------------------------"
rpm -qa | grep mod_security > /dev/null && dnf remove -y mod_security*

dnf install -y libcurl libcurl-devel yajl yajl-devel libxml2 libxml2-devel ssdeep ssdeep-devel lua lua-devel lmdb lmdb-devel lmdb-libs GeoIP GeoIP-devel

# ------------------------------------
# Install libmodsecurity (ModSecurity for Nginx)
# ------------------------------------
#dnf install -y libmodsecurity*

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
./configure -q #--enable-parser-generation --enable-mutex-on-pm --without-lmdb
make -s || { echo "FATAL: make" ; exit 1; }
make -s install || { echo "FATAL: make install" ; exit 1; }

echo 

# ***********************************************************************************************************

# ------------------------------------
# Stop
# ------------------------------------
stop_script
