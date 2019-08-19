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
task_copy_using_render_sed

# ******* Install nginx headers_more module *******
echo "========================================="
echo "   Install Nginx headers_more module..."
echo "========================================="
${headers_install_script}

