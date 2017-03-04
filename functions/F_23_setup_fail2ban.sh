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
# Rendering fail2ban config
#--------------------------------------
echo "========================================="
echo "  Rendering fail2ban configuration"
echo "========================================="
local fail2ban_confs=($(find ${CONFIG_FOLDER} -type f))
local fail2ban_target=""
local fail2ban_target_folder=""
for fail2ban_conf in ${fail2ban_confs[@]}
do
  fail2ban_target="${fail2ban_conf/${CONFIG_FOLDER}/}"
  fail2ban_target_folder="$(dirname $fail2ban_target)"

  test -d $fail2ban_target_folder || mkdir -p $fail2ban_target_folder
  # use RENDER_CP to fetch var from datadog
  RENDER_CP $fail2ban_conf $fail2ban_target
done

#--------------------------------------
# Start firewalld & fail2ban
#--------------------------------------
# Start and Enable firewalld service
systemctl start firewalld
systemctl enable firewalld.service

systemctl start fail2ban
systemctl enable fail2ban.service
fail2ban-client reload

