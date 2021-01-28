#**********************************************
# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ "${certbot_apply_action}" != "webroot" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


# Init action
. ${PLUGINS}/plugin_certbot_path.sh
# Before action
. ${PLUGINS}/plugin_certbot_install_check.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert with WEBROOT verification

echo "---Make sure Nginx is started for the site (${certbot_servername})---"
local response_server_type="$(curl -Is http://${certbot_servername} | grep 'Server')"

echo "curl -Is http://${certbot_servername}"

if [[ -z "${response_server_type}" ]]; then
  echo "URL is not alive: http://${certbot_servername}"
  eval "${SKIP_SCRIPT}"
fi

echo "===> ${response_server_type}"
echo ""

echo "---Apply cert using certbot via webroot---"
$certbot_command --agree-tos -m $certbot_email --no-eff-email certonly --webroot -w $certbot_webroot -d $certbot_servername -n -q
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
