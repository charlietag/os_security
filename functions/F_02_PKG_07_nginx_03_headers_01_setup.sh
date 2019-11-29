# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"

# ******* Setup Nginx scripts*******
echo "========================================="
echo "* Setup Nginx scripts"
echo "========================================="
helper_nginx_scripts

# ******* Setup Nginx config *******
echo "========================================="
echo "* Setup Nginx configs for Nginx headers_more module"
echo "========================================="
task_copy_using_render_sed

