# =====================
# Enable databag
# =====================
# RENDER_CP

# =====================
# Install libmodsecurity (ModSecurity for Nginx) + ModSecurity-nginx-connector

# ******* Install / update : libmodsecurity / Nginx-modsecurity-connector *******
echo "========================================="
echo "   Install / update : libmodsecurity / Nginx-modsecurity-connector"
echo "========================================="
${modsec_install_script}

echo "========================================="
echo "   Setup OWASP CRS rules"
echo "========================================="
${owasp_install_script}

