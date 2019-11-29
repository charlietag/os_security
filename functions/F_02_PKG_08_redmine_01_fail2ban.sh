# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"

# =====================
echo "========================================="
echo "   Setup fail2ban for redmine (Failed login)"
echo "========================================="

# Replace template with variable
task_copy_using_render_sed

echo "---reload fail2ban---"
fail2ban-client reload

echo "--------------Fail2ban Status-------------"
fail2ban-client status

