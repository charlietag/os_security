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
  echo "---Apply cert using certbot via dns txt record---"
  $certbot_command --agree-tos -m $certbot_email  --no-eff-email certonly --manual --preferred-challenges dns  -d $certbot_servername

  # **************** End *******************

  $certbot_command certificates
else
  echo "${certbot_command} does not exists....!!"
  exit 1
fi
# ******* Start to apply letsencrypt SSL cert with DNS txt record verification End *******
