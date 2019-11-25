# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# =====================
echo "========================================="
echo "   Setup fail2ban for redmine (Failed login)"
echo "========================================="

# To make sure script is executable, using cp script first, this will copy file attr as well
task_copy_using_cp

# Replace template with variable
task_copy_using_render_sed

echo "---reload fail2ban---"
fail2ban-client reload

echo "--------------Fail2ban Status-------------"
fail2ban-client status
