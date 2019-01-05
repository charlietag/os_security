# =====================
# Enable databag
# =====================
# RENDER_CP

# =====================
echo "========================================="
echo "   Setup fail2ban for Nginx-modsecurity (Nginx WAF)"
echo "========================================="
task_copy_using_cat

echo "---reload fail2ban---"
fail2ban-client reload
