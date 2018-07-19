# =====================
# Enable databag
# =====================
# RENDER_CP

# Convert array to multiple lines
# ### ng_limit_req_logpaths ###
local ng_limit_req_logpath="$(echo -e "$(echo "${ng_limit_req_logpaths[@]}" | sed -e 's/\s\+/\n  /g' )" )"

# ### ng_botsearch_logpaths ###
local ng_botsearch_logpath="$(echo -e "$(echo "${ng_botsearch_logpaths[@]}" | sed -e 's/\s\+/\n  /g' )" )"

#--------------------------------------
# Installing script
#--------------------------------------
# *********************************
# Install f2b.sh script
# *********************************
local f2b_command="/root/bin/f2b"
echo "fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed \"s/\\s//g\" | tr ',' '\\n' |xargs -i bash -c \"echo \\\"----{}----\\\" ;fail2ban-client status {} ; echo \"" > $f2b_command
chmod 755 $f2b_command

# *********************************
# Adding f2b.sh into crontab
# *********************************
sed -i /f2b/d /etc/crontab
echo "1 0 * * * root ${f2b_command}" >> /etc/crontab

#--------------------------------------
# Rendering fail2ban config
#--------------------------------------
echo "========================================="
echo "  Rendering fail2ban configuration"
echo "========================================="
task_copy_using_render

#--------------------------------------
# Start firewalld & fail2ban
#--------------------------------------
# Start and Enable firewalld service
echo "---stopping firewalld---"
systemctl stop firewalld
echo "---stopping fail2ban---"
systemctl stop fail2ban

echo "---starting firewalld---"
systemctl start firewalld
echo "---starting fail2ban---"
systemctl start fail2ban

echo "---enable firewalld---"
systemctl enable firewalld.service
echo "---enable fail2ban---"
systemctl enable fail2ban.service

echo "---reload fail2ban---"
fail2ban-client reload

#--------------------------------------
# Make sure firewalld works with fail2ban well
#--------------------------------------
echo "--------------Firewalld Rules-------------"
firewall-cmd --list-all

echo "--------------IPTABLES Rules of fail2ban-------------"
echo -n "Waiting fail2ban for inserting rules into firewalld(iptables)"
echo -n "."; sleep 1; echo -n "."; sleep 1; echo "."; sleep 1

iptables -S | grep -i fail2ban
sleep 3

echo "--------------Fail2ban Status-------------"
fail2ban-client status

echo "--------------Fail2ban Detail Status-------------"
fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' |xargs -i bash -c "echo \"----{}----\" ;fail2ban-client status {} ; echo "

