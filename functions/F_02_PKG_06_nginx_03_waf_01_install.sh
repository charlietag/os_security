# =====================
# Enable databag
# =====================
# RENDER_CP

# =====================
# Install libmodsecurity (ModSecurity for Nginx) + ModSecurity-nginx-connector

# ******* Install Nginx-modsecurity update script *******
echo "========================================="
echo "1. Setup install update Nginx-modsecurity scripts"
echo "2. Setup Nginx configs for Nginx-WAF"
echo "========================================="
task_copy_using_cat

chmod 755 /opt/nginxwaf_scripts/*.sh

# *********************************
# Adding nginx waf related update scripts into crontab
# *********************************
echo "Adding nginx waf related update scripts into crontab..."
sed -i /ngx-/d /etc/crontab
echo "1 2 * * * root ${modsec_install_script} && ${owasp_install_script}" >> /etc/crontab

