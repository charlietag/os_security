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
echo "---Renewing all certs using certbot via dns txt record---"
$certbot_command renew -n
#**********************************************

#**********************************************
# After action
. ${FUNCTIONS}/_certbot_after.sh
#**********************************************
