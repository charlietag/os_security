# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ******* Setup Nginx scripts*******
echo "========================================="
echo "* Setup Nginx scripts"
echo "========================================="
helper_nginx_scripts

# ******* Setup Nginx config *******
echo "========================================="
echo "* Setup Nginx configs for Nginx-WAF"
echo "========================================="
task_copy_using_render

