# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ "${ng_waf_rules}" != "OWASP" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


# =====================
# Install ModSecurity OWASP CRS rules

echo "========================================="
echo "   Install ModSecurity OWASP CRS rules... (should be done while step: setup)"
echo "========================================="

