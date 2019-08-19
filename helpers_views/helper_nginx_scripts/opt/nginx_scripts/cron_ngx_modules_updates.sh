#!/bin/bash
# ------------------------------------
# Scripts Path
# ------------------------------------
PACKAGE_SCRIPTS_PATH="$(dirname $(readlink -m $0))"

# ------------------------------------
# Install & Update
# To be able to execute each script separately.
# Do not source lib scripts here(in each script instead)
# Run script by running absolute path, NOT source script (like . path/script.sh)
# ------------------------------------

# =============== headers_more ===================
${PACKAGE_SCRIPTS_PATH}/package_ngx_headers.sh

# =============== WAF ===================
${PACKAGE_SCRIPTS_PATH}/package_ngx_waf.sh
