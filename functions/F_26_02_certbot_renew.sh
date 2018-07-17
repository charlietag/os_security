#**********************************************
# =====================
# Enable databag
# =====================
# RENDER_CP

# Init action
. ${HELPERS}/plugin_certbot_path.sh
# Before action
. ${HELPERS}/plugin_certbot_install_check.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert "ONLY" with "WEBROOT" verification
echo "---Renewing all certs using certbot via \"ONLY WEBROOT\"---"
$certbot_command renew -n
#**********************************************

#**********************************************
# After action
. ${HELPERS}/plugin_certbot_show_certs.sh
#**********************************************
