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
# Start to apply letsencrypt SSL cert with WEBROOT verification
echo "---Apply cert using certbot via webroot---"
$certbot_command --agree-tos -m $certbot_email --no-eff-email certonly --webroot -w $certbot_webroot -d $certbot_servername
#**********************************************

#**********************************************
# After action
. ${FUNCTIONS}/_certbot_after.sh
#**********************************************
