# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# =====================
echo "========================================="
echo "   Setup fail2ban for redmine (Failed login)"
echo "========================================="

# Replace template with variable
task_copy_using_render_sed

echo "---reload fail2ban---"
fail2ban-client reload

echo "--------------Fail2ban Status-------------"
fail2ban-client status


local cron_redmine_f2b_script="/opt/redmine_scripts/cron_redmine_f2b.sh"
chmod 755 ${cron_redmine_f2b_script}
# *********************************
# Failed logged in check script into crontab
# *********************************
echo "========================================="
echo "   Setup cron for cron_redmine_f2b.sh"
echo "========================================="
echo "Adding script into crontab..."
sed -i /cron_redmine_f2b/d /etc/crontab
echo "*/5 * * * * root ${cron_redmine_f2b_script}" >> /etc/crontab

