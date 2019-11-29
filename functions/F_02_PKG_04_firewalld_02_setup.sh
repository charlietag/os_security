# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"




#--------------------------------------
# check if firewalld is installed
#--------------------------------------
if ! $(rpm -q --quiet firewalld)
then
  echo "WARNING:Firewalld is not installed!..."
  echo "Please install package \"firewalld\""
  exit 1
fi

#--------------------------------------
# Start to setup firewall rules
#--------------------------------------
# Start and Enable firewalld service
systemctl start firewalld
systemctl enable firewalld.service

# Cleanup firewall rules which means block all incoming traffice
echo "========================================="
echo "      Blocking all incoming traffic using zone \"public\""
echo "========================================="
task_copy_using_cp

firewall-cmd --reload

# Setup allowed incoming traffic

echo "========================================="
echo "      Allowing incoming traffic using zone \"public\""
echo "========================================="
for firewalld_allow_known_service in ${firewalld_allow_known_services[@]}
do
  echo "Allowing traffic \"${firewalld_allow_known_service}\"......."
  firewall-cmd --add-service=${firewalld_allow_known_service} --permanent
done

for firewalld_allow_customized_port in ${firewalld_allow_customized_ports[@]}
do
  echo "Allowing traffic \"${firewalld_allow_customized_port}\"......."
  firewall-cmd --add-port=${firewalld_allow_customized_port} --permanent
done
firewall-cmd --reload

echo "---stopping firewalld---"
systemctl stop firewalld
echo "---starting firewalld---"
systemctl start firewalld

echo "--------------Firewalld Rules-------------"
firewall-cmd --list-all
