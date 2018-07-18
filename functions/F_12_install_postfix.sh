# =====================
# Enable databag
# =====================
# RENDER_CP

#--------------------------------------
# Start - install postfix
#--------------------------------------
yum install -y postfix
yum install -y cyrus-sasl-md5 cyrus-sasl-plain cyrus-sasl
systemctl stop postfix

#--------------------------------------
# Rendering postfix config
#--------------------------------------
task_copy_using_render

#--------------------------------------
# Setup cron mail config
#--------------------------------------
echo "Setting up crontab..."
sed -i /MAILTO/d /etc/crontab
sed -i /MAILFROM/d /etc/crontab
sed -e "/^PATH/a MAILTO=${cron_mail_to}" -i /etc/crontab
sed -e "/^PATH/a MAILFROM=${cron_mail_from}" -i /etc/crontab

#--------------------------------------
# Setup mail alias
#--------------------------------------
echo "Setting up etc aliases..."
sed -i /root:/d /etc/aliases
echo "root:  ${mail_root_alias}" >> /etc/aliases
$(which newaliases)

#--------------------------------------
# Setup sasl_passwd
#--------------------------------------
echo "Setting up sasl_passwd..."
chmod 400 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

#--------------------------------------
# End - install postfix
#--------------------------------------
echo "Restarting postfix..."
systemctl restart postfix
systemctl enable postfix
