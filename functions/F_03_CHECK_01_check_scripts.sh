echo "========================================="
echo "   Setup check scripts"
echo "========================================="
task_copy_using_cp

local cron_check_script="/opt/check_scripts/cron_check_script.sh"
chmod 755 ${cron_check_script}
# *********************************
# Failed logged in check script into crontab
# *********************************
echo "========================================="
echo "   Setup cron for f2b_nginx_check_banned.sh"
echo "========================================="
echo "Adding script into crontab..."
sed -i /cron_check_script.sh/d /etc/crontab
echo "1 * * * * root ${cron_check_script}" >> /etc/crontab


