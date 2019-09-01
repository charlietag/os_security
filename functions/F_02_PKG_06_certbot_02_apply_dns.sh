#**********************************************
# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ "${certbot_apply_action}" != "dns" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


# Init action
. ${PLUGINS}/plugin_certbot_path.sh
# Before action
. ${PLUGINS}/plugin_certbot_install_check.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert with DNS txt record verification
echo "---Apply cert using certbot via dns txt record---"
$certbot_command --agree-tos -m $certbot_email --no-eff-email certonly --manual --preferred-challenges dns -d $certbot_servername
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
