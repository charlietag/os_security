# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# =====================
echo "========================================="
echo "   Setup fail2ban for Nginx-modsecurity (Nginx WAF)"
echo "========================================="
task_copy_using_render

echo "---reload fail2ban---"
fail2ban-client reload

echo "--------------Fail2ban Status-------------"
fail2ban-client status
