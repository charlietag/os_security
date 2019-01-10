#!/bin/bash

# nginx headers_more module
/opt/nginx_scripts/headers_01_headers_more_install.sh

# nginx waf module
/opt/nginx_scripts/waf_02_nginx_connector_install.sh
/opt/nginx_scripts/waf_03_owasp_install.sh
