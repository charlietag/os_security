# =====================
# Enable databag
# =====================
# RENDER_CP

# =====================
# Install libmodsecurity (ModSecurity for Nginx) + ModSecurity-nginx-connector

# ******* Install Nginx-modsecurity update script *******
echo "========================================="
echo "   Install update Nginx-modsecurity scripts"
echo "========================================="
# Build and install ngx_http_modsecurity_module.so 
${modsec_install_script}
${owasp_install_script}

