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
# Start to apply letsencrypt SSL cert with WEBROOT verification
echo "---Apply cert using certbot via webroot---"
$certbot_command --agree-tos -m $certbot_email --no-eff-email certonly --webroot -w $certbot_webroot -d $certbot_servername -n -q
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
