#**********************************************
# =====================
# Enable databag
# =====================
# RENDER_CP

# Init action
. ${FUNCTIONS}/_certbot_init.sh
# Before action
. ${FUNCTIONS}/_certbot_before.sh
#**********************************************

#**********************************************
# Start to apply letsencrypt SSL cert with DNS txt record verification
echo "---Apply cert using certbot via dns txt record---"
$certbot_command --agree-tos -m $certbot_email --no-eff-email certonly --manual --preferred-challenges dns -d $certbot_servername
#**********************************************

#**********************************************
# After action
. ${FUNCTIONS}/_certbot_after.sh
#**********************************************
