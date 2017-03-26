#--------------------------------------
# Start - install postfix
#--------------------------------------
yum install -y postfix
yum install -y cyrus-sasl-md5 cyrus-sasl-plain cyrus-sasl
systemctl stop postfix

#--------------------------------------
# Rendering postfix config
#--------------------------------------
echo "========================================="
echo "  Rendering postfix configuration"
echo "========================================="
local postfix_confs=($(find ${CONFIG_FOLDER} -type f))
local postfix_target=""
local postfix_target_folder=""
for postfix_conf in ${postfix_confs[@]}
do
  postfix_target="${postfix_conf/${CONFIG_FOLDER}/}"
  postfix_target_folder="$(dirname $postfix_target)"

  test -d $postfix_target_folder || mkdir -p $postfix_target_folder
  # use RENDER_CP to fetch var from datadog
  RENDER_CP $postfix_conf $postfix_target
done

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
