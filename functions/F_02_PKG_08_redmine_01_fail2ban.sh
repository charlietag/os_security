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

