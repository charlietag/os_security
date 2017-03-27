# =====================
# Enable databag
# =====================
# RENDER_CP

# ******* Define var *******
local certbot_root="/opt"
local certbot_path="${certbot_root}/certbot"
local certbot_command="${certbot_path}/certbot-auto"

# ******* Fetching / Update certbot *******
if [ -d $certbot_path ]
then
  echo "---Updating CERTBOT---"
  cd $certbot_path
  git pull
else
  echo "---Downloading CERTBOT---"
  cd $certbot_root
  git clone $certbot_src_url
fi

systemctl disable httpd

# *********************************
# Adding certificates renewal into crontab
# *********************************
sed -i /certbot-auto/d /etc/crontab
echo "1 3 1 * * root ${certbot_command} renew -n -q" >> /etc/crontab
