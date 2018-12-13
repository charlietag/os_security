# =====================
# Enable databag
# =====================
# RENDER_CP

# Install libmodsecurity (ModSecurity for Nginx)
yum install -y libmodsecurity*

# ******* Install Nginx-modsecurity update script *******
echo "========================================="
echo "   Setup install update Nginx-modsecurity script"
echo "========================================="
task_copy_using_cat

# Build and install ngx_http_modsecurity_module.so 
git clone --depth 1 -b v1.0.0 https://github.com/SpiderLabs/ModSecurity-nginx.git



