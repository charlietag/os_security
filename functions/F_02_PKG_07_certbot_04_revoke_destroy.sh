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
echo "---Warning: this cannot be rollback!---"
echo "---Revoke and Delete all certs using certbot---"
echo -n "Are you sure (Yes/No)? "
local revoke_confirm="N"
read revoke_confirm
if [ "${revoke_confirm}" != 'Yes' ]
then
  echo "canceled..."
  exit
fi

$certbot_command revoke --cert-path /etc/letsencrypt/live/${certbot_servername}/cert.pem
$certbot_command delete --cert-name ${certbot_servername}
#**********************************************

#**********************************************
# After action
. ${PLUGINS}/plugin_certbot_show_certs.sh
#**********************************************
