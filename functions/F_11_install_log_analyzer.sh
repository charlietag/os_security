# ***************************
# logwatch
# ***************************
yum install -y logwatch

# ***************************
# logwatch
# ***************************
yum install -y goaccess

# ***************************
# Postfix log parse
# ref. http://www.postfix.org/addon.html#logfile
# ***************************
yum install -y postfix-perl-scripts
sed -i /pflogsumm/d /etc/crontab
echo "01 01 * * * root /usr/sbin/pflogsumm -d yesterday /var/log/maillog" >> /etc/crontab

# ***************************
# setup config
# ***************************
task_copy_using_cat
