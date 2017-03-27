# =====================
# Enable databag
# =====================
# RENDER_CP

# ******* Define var *******
local certbot_root="/opt"
local certbot_path="${certbot_root}/certbot"
local certbot_command="${certbot_path}/certbot-auto"

# ******* Start to apply letsencrypt SSL cert with DNS txt record verification *******
if [ -f "$certbot_command" ]
then

  # **************** Start *******************
  echo "---Warning: this cannot be rollback! Revoke and Delete all certs using certbot via dns txt record---"
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
  # **************** End *******************
  
  $certbot_command certificates
else
  echo "${certbot_command} does not exists....!!"
  exit 1
fi
# ******* Start to apply letsencrypt SSL cert with DNS txt record verification End *******

echo "disable httpd server..."
systemctl disable httpd
systemctl stop httpd
