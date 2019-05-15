#**********************************************
# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# Init action
. ${PLUGINS}/plugin_certbot_path.sh
# Before action
. ${PLUGINS}/plugin_certbot_install_check.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert "ONLY" with "WEBROOT" verification
echo "---Renewing all certs using certbot via \"ONLY WEBROOT\"---"
$certbot_command renew -n
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
