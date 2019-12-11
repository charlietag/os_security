# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# Convert array to multiple lines
# ### ng_limit_req_logpaths ###
#local ng_limit_req_logpath="$(echo -e "$(echo "${ng_limit_req_logpaths[@]}" | sed -e 's/\s\+/\n  /g' )" )"

# ### ng_botsearch_logpaths ###
#local ng_botsearch_logpath="$(echo -e "$(echo "${ng_botsearch_logpaths[@]}" | sed -e 's/\s\+/\n  /g' )" )"

# ------------------------------------
# define script location
# ------------------------------------
local cron_check_script="/root/bin/f2b"


# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure this script can be run multiple times
sed -i /"${cron_check_script//\//\/}"/d /etc/crontab

# Make sure apply action is currect.
[[ -z "$(echo "${cron_check_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"

#--------------------------------------
# Installing script
#--------------------------------------
# *********************************
# Install f2b.sh script
# *********************************
#local cron_check_script="/root/bin/f2b"

local cron_check_script_dir="$(dirname $cron_check_script)"
test -d $cron_check_script_dir || mkdir -p $cron_check_script_dir

echo "fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed \"s/\\s//g\" | tr ',' '\\n' |xargs -i bash -c \"echo \\\"----{}----\\\" ;fail2ban-client status {} ; echo \"" > $cron_check_script
chmod 755 $cron_check_script

# *********************************
# Adding f2b.sh into crontab
# *********************************
echo "1 0 * * * root ${cron_check_script}" >> /etc/crontab

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
echo "---stopping fail2ban---"
systemctl stop fail2ban

sleep 2

echo "---stopping firewalld---"
systemctl stop firewalld

sleep 2


echo "---starting firewalld---"
systemctl start firewalld

sleep 2

echo "---starting fail2ban---"
systemctl start fail2ban

echo "---enable firewalld---"
systemctl enable firewalld.service
echo "---enable fail2ban---"
systemctl enable fail2ban.service

sleep 2


#echo "---reload fail2ban---"
#fail2ban-client reload

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

