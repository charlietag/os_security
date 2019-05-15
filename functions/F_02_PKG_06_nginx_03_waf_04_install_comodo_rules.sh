# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ "${ng_waf_rules}" != "COMODO" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


# =====================
# Install ModSecurity COMODO rules

echo "========================================="
echo "   Install ModSecurity COMODO rules..."
echo "========================================="
${comodo_install_script}

