yum install -y fail2ban
systemctl stop fail2ban
systemctl disable fail2ban.service

# *********************************
# Install f2b.sh script
# *********************************
local f2b_command="/root/bin/f2b.sh"
echo "fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed \"s/\\s//g\" | tr ',' '\\n' |xargs -i bash -c \"echo \\\"----{}----\\\" ;fail2ban-client status {} ; echo \"" > $f2b_command
chmod 755 $f2b_command

# *********************************
# Adding f2b.sh into crontab
# *********************************
sed -i /f2b.sh/d /etc/crontab
echo "1 0 * * * root ${f2b_command}" >> /etc/crontab
