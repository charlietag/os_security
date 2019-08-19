#!/bin/bash
# ------------------------------------
# Scripts Path
# ------------------------------------
SCRIPTS_PATH="$(dirname $(readlink -m $0))/scripts"
chmod 755 ${SCRIPTS_PATH}/*.sh


# ------------------------------------
# Install & Update
# To be able to execute each script separately.
# Do not source lib scripts here(in each script instead)
# Run script by running absolute path, NOT source script (like . path/script.sh)
# ------------------------------------
# nginx headers_more module
${SCRIPTS_PATH}/headers_01_headers_more_install.sh
