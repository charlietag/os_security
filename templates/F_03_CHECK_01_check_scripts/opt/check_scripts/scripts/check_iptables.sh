check_iptables() {
  local f2b_iptables="$(iptables -S |grep fail2ban)"
  if [[ -z "${f2b_iptables}" ]]; then
    display_check_name
    #echo "${f2b_iptables}"
    echo "Firewalld is not running correctly!"
  fi
}
