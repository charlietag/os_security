echo "========================================="
echo "   Setup fail2ban for Nginx banned IP check"
echo "========================================="
task_copy_using_cp

local cron_script_f2b_nginx_check_banned="/opt/f2b_scripts/f2b_nginx_check_banned.sh"
chmod 755 ${cron_script_f2b_nginx_check_banned}
# *********************************
# Failed logged in check script into crontab
# *********************************
echo "========================================="
echo "   Setup cron for f2b_nginx_check_banned.sh"
echo "========================================="
echo "Adding script into crontab..."
sed -i /f2b_nginx_check_banned.sh/d /etc/crontab
echo "*/15 * * * * root ${cron_script_f2b_nginx_check_banned}" >> /etc/crontab

