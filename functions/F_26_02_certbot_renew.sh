# ******* Define var *******
local certbot_root="/opt"
local certbot_path="${certbot_root}/certbot"
local certbot_command="${certbot_path}/certbot-auto"

# ******* Start to apply letsencrypt SSL cert with DNS txt record verification *******
if [ -f "$certbot_command" ]
then

  # **************** Start *******************
  echo "---Renewing all certs using certbot via dns txt record---"
  $certbot_command renew -n

  # **************** End *******************

  $certbot_command certificates
else
  echo "${certbot_command} does not exists....!!"
  exit 1
fi
# ******* Start to apply letsencrypt SSL cert with DNS txt record verification End *******
