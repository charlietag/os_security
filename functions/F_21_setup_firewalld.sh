# =====================
# Enable databag
# =====================
# RENDER_CP
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
local firewalld_confs=($(find ${CONFIG_FOLDER} -type f))
local firewalld_target=""
local firewalld_target_folder=""
for firewalld_conf in ${firewalld_confs[@]}
do
  firewalld_target="${firewalld_conf/${CONFIG_FOLDER}/}"
  firewalld_target_folder="$(dirname $firewalld_target)"

  test -d $firewalld_target_folder || mkdir -p $firewalld_target_folder
  echo "Setting up config file \"${firewalld_target}\"......"
  \cp -a --backup=t $firewalld_conf $firewalld_target
done
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

