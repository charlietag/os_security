# =====================
# Enable databag
# =====================
# RENDER_CP

# Install libmodsecurity (ModSecurity for Nginx)
# The following is done by ngx-waf script
#yum install -y libmodsecurity*

# ******* Install Nginx-modsecurity update script *******
echo "========================================="
echo "   Setup install update Nginx-modsecurity scripts"
echo "========================================="
task_copy_using_cat

chmod 755 /opt/nginxwaf_scripts/*.sh

# Build and install ngx_http_modsecurity_module.so 
/opt/nginxwaf_scripts/ngx-modsecurity_install_update.sh
/opt/nginxwaf_scripts/ngx-owasp-crs_install_update.sh


# *********************************
# Adding nginx waf related update scripts into crontab
# *********************************
echo "Adding nginx waf related update scripts into crontab..."
#sed -i /certbot-auto_renew/d /etc/crontab
#echo "1 3 * * * root ${certbot_renew_script}" >> /etc/crontab




