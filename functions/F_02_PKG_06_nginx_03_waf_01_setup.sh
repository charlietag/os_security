# =====================
# Enable databag
# =====================
# RENDER_CP

# =====================

# ******* Setup Nginx scripts*******
echo "* Setup install update Nginx-modsecurity scripts"
helper_nginx_scripts

# Install libmodsecurity (ModSecurity for Nginx) + ModSecurity-nginx-connector

# ******* Install Nginx-modsecurity update script *******
echo "========================================="
echo "* Setup Nginx configs for Nginx-WAF"
echo "========================================="
task_copy_using_cat

# *********************************
# Adding nginx waf related update scripts into crontab
# *********************************
echo "Adding nginx waf related update scripts into crontab..."
sed -i /waf_/d /etc/crontab
echo "1 2 * * * root ${connector_install_script}" >> /etc/crontab
echo "30 2 * * * root ${owasp_install_script}" >> /etc/crontab

