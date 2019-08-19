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
# nginx waf module
${SCRIPTS_PATH}/waf_01_libmodsecurity_install.sh
${SCRIPTS_PATH}/waf_02_nginx_connector_install.sh
${SCRIPTS_PATH}/waf_03_rules_comodo_apply.sh
${SCRIPTS_PATH}/waf_03_rules_owasp_apply.sh
