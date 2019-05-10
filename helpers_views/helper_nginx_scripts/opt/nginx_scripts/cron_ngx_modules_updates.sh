#!/bin/bash
# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/lib/ngx-script-lib.sh"


# ------------------------------------
# Install & Update
# ------------------------------------
# nginx headers_more module
${THIS_PATH_BASE}/headers_01_headers_more_install.sh

# nginx waf module
${THIS_PATH_BASE}/waf_01_libmodsecurity_install.sh
${THIS_PATH_BASE}/waf_02_nginx_connector_install.sh
${THIS_PATH_BASE}/waf_03_rules_comodo_apply.sh
${THIS_PATH_BASE}/waf_03_rules_owasp_apply.sh
