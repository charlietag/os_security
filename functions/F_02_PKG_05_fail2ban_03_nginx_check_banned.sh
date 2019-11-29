# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# define script location
# ------------------------------------
local cron_check_script="/opt/f2b_scripts/f2b_nginx_check_banned.sh"


# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure this script can be run multiple times
sed -i /"${cron_check_script//\//\/}"/d /etc/crontab

# Make sure apply action is currect.
[[ -z "$(echo "${cron_check_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"



#--------------------------------------
# Start to setup script
#--------------------------------------
echo "========================================="
echo "   Setup for $(basename ${cron_check_script})"
echo "========================================="
task_copy_using_cp

chmod 755 ${cron_check_script}
# *********************************
# Failed logged in check script into crontab
# *********************************
echo "========================================="
echo "   Setup cron for $(basename ${cron_check_script})"
echo "========================================="
echo "Adding script into crontab..."
#sed -i /"${cron_check_script//\//\/}"/d /etc/crontab
echo "*/15 * * * * root ${cron_check_script}" >> /etc/crontab

