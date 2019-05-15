#**********************************************
# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ "${certbot_apply_action}" != "dns-cloudflare" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------

# Init action
. ${PLUGINS}/plugin_certbot_path.sh
# Before action
. ${PLUGINS}/plugin_certbot_install_check.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert with DNS txt record verification
echo "---Install dns-cloudflare if needed  ---"
IF_CF="$($certbot_python_pip_command list --format=columns | grep certbot-dns-cloudflare)"
if [[ -z "$IF_CF" ]]; then
  $certbot_python_pip_command install certbot-dns-cloudflare
else
  echo "Pass..."
fi

echo "--- Generate cloudflare ini file---"
test -d $certbot_cf_path || mkdir -p $certbot_cf_path
echo "${certbot_cf_path} ...done"

echo "dns_cloudflare_email = ${certbot_dns_cloudflare_email}" > $certbot_cf_ini
echo "dns_cloudflare_api_key = ${certbot_dns_cloudflare_api_key}" >> $certbot_cf_ini
chmod 400 $certbot_cf_ini
echo "${certbot_cf_ini} ...done"


echo "---Apply cert using certbot via dns-cloudflare plugin ---"
$certbot_command \
  --agree-tos -m $certbot_email --no-eff-email \
  certonly \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --dns-cloudflare \
  --dns-cloudflare-credentials $certbot_cf_ini \
  --dns-cloudflare-propagation-seconds $certbot_wait_cf_seconds \
  -d $certbot_servername \
  -d ${certbot_wild_servername}
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
