# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${postfix_installation}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


#--------------------------------------
# Start - install postfix
#--------------------------------------
yum install -y postfix
yum install -y cyrus-sasl-md5 cyrus-sasl-plain cyrus-sasl
systemctl stop postfix
