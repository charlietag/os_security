# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"

#--------------------------------------
# Start to setup script
#--------------------------------------
task_copy_using_cat

echo "-------------------------------------------------------------"
echo "Generating openssl dhparam."
echo "This might take \"several minutes!\""
echo "Base on your server spec. This might take even \"up to hours\"...!"
echo "-------------------------------------------------------------"
local ssl_dhparam_file="/etc/nginx/server_features/SSL/ssl_dhparam/dhparam2048.pem"
test -f $ssl_dhparam_file || $(which openssl) dhparam -out $ssl_dhparam_file 2048
