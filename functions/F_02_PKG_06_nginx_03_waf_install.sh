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

# Build and install ngx_http_modsecurity_module.so 
/opt/nginxwaf_scripts/ngx-modsecurity_install_update.sh




