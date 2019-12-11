# =====================
# Check SSH Config
# =====================
local hosts_config_file="/etc/hosts"
local this_hostname="$(hostname)"

# =====================
# Pring out message function
# =====================
print_msg (){
  local err_code=$1
  local err_msg="$2"

  if [ ${err_code} -eq 1 ]
  then
    echo -ne '\e[1;31m'
    echo "Warning : ${err_msg}"
    echo -n -e '\033[00m'

    echo "This might cause fail2ban WARNING !"
    echo "Ref. https://github.com/charlietag/os_security#fail2ban-usage"

  else
    echo -ne '\e[1;32m'
    echo "OK : ${err_msg}"
    echo -n -e '\033[00m'
  fi

}

# =====================
# Check for IPv4
# =====================
local hosts_ipv4="$(cat /etc/hosts | grep -v '#' |grep -E "127.0.0.1[[:print:]]*( ${this_hostname}$| ${this_hostname} )")"
if [ ! -z "${hosts_ipv4}" ]
then
  print_msg 0 "hostname \"${this_hostname}\" found in /etc/hosts for IPv4"
  echo -e "${hosts_ipv4}"
else
  print_msg 1 "hostname \"${this_hostname}\" NOT found in /etc/hosts for IPv4"
fi



# =====================
# Check for IPv6
# =====================
local hosts_ipv6="$(cat /etc/hosts | grep -v '#' |grep -E "::1[[:print:]]*( ${this_hostname}$| ${this_hostname} )")"
if [ ! -z "${hosts_ipv6}" ]
then
  print_msg 0 "hostname \"${this_hostname}\" found in /etc/hosts for IPv6"
  echo -e "${hosts_ipv6}"
else
  print_msg 1 "hostname \"${this_hostname}\" NOT found in /etc/hosts for IPv6"
fi
