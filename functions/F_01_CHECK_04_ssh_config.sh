# =====================
# Check SSH Config
# =====================
local ssh_config_file="/etc/ssh/sshd_config"

# =====================
# Pring out message function
# =====================
print_msg (){
  local err_code=$1
  local err_msg="$2"

  if [ ${err_code} -eq 1 ]
  then
    echo "Warning : ${err_msg}"
  else
    echo "OK : ${err_msg}"
  fi

}

# =====================
# Check SSH PermitRootLogin
# =====================
local permit_root_no="$(cat ${ssh_config_file} |grep -Eo "^PermitRootLogin[ ]+no$")"
if [ ! -z "${permit_root_no}" ]
then
  print_msg 0 "PermitRootLogin check"
else
  print_msg 1 "PermitRootLogin set to yes"
fi



# =====================
# Check SSH Port in 22
# =====================
local port_check="$(cat ${ssh_config_file} | grep -Eo "^Port[ ]+22$")"
if [ ! -z "${port_check}" ]
then
  print_msg 1 "SSH listen port set to 22"
else
  print_msg 0 "SSH listen port check"
fi
