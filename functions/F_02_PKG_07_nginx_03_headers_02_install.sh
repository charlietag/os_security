# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# =====================
# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"


# ******* Install nginx headers_more module *******
echo "========================================="
echo "   Install Nginx headers_more module..."
echo "========================================="
echo "This might take a little bit longer... please wail for awhile"
${headers_install_script}

