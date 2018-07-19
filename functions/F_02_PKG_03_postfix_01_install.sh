#--------------------------------------
# Start - install postfix
#--------------------------------------
yum install -y postfix
yum install -y cyrus-sasl-md5 cyrus-sasl-plain cyrus-sasl
systemctl stop postfix
