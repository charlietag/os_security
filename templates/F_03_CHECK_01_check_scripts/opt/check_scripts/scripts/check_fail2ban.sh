test_fail2ban_config_status() {
  local f2b_status="$(fail2ban-client status | tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n'|sort -n )"
  local f2b_config="$(cat /etc/fail2ban/jail.local /etc/fail2ban/jail.d/*.local |grep -E "\[[^[:space:]]+\]$" | grep -v "DEFAULT" | grep -vE "^#" | sed -re 's/^\[//g' | sed -re 's/\]$//g' | sort -n )"
  local f2b_iptables="$(iptables -S | grep -Eo "f2b-[^[:space:]]+" | sed 's/f2b-//g' | sort -n )"
  local f2b_ipset="$(ipset list | grep -Eo "f2b-[^[:space:]]+" | sed 's/f2b-//g' | sort -n )"

  local diff_check="$(  diff <(echo "${f2b_status}") <(echo "${f2b_config}")    ; \
                        diff <(echo "${f2b_status}") <(echo "${f2b_iptables}")  ; \
                        diff <(echo "${f2b_status}") <(echo "${f2b_ipset}")  
                    )"
  if [[ -n "${diff_check}" ]]; then
    echo "--------------------------------------------------------"
    echo "fail2ban config is not loaded correctly!"
    echo "--------------------------------------------------------"
    echo -e "----- fail2ban-client status ---"
    echo -e "${f2b_status}"
    echo ""

    echo -e '----- cat /etc/fail2ban/jail.local /etc/fail2ban/jail.d/*.local ---'
    echo -e "${f2b_config}"
    echo ""

    echo -e '----- iptables -S ---'
    echo -e "${f2b_iptables}"
    echo ""

    echo -e '----- ipset list ---'
    echo -e "${f2b_ipset}"
  fi
}

test_ipset() {
  local ipset_ban_jail="f2b-${1}"
  local test_ban_ip="${2}"
  local ipset_list="$(ipset list ${ipset_ban_jail} | grep "${test_ban_ip}" )"
  [[ -z "${ipset_list}" ]] && echo -e "ipset \"${ipset_ban_jail}\":\t\t... WARNING"
}

test_ban() {
  local test_ban_ip="10.255.255.254"
  local f2b_jails="$(cat /etc/fail2ban/jail.local /etc/fail2ban/jail.d/*.local |grep -E "\[[^[:space:]]+\]$" | grep -v "DEFAULT" | grep -vE "^#" | sed -re 's/^\[//g' | sed -re 's/\]$//g' | sort -n )"
  local test_ipset_warning
  local test_ipset_warning_found

  # --- Check ipset by f2b jail names one by one ---
  for f2b_jail in ${f2b_jails[@]}; do
    test_ipset_warning_found="N"
    # --- First Check ---
    test_ipset_warning="$(test_ipset "${f2b_jail}" "${test_ban_ip}")"
    if [[ -n "${test_ipset_warning}" ]]; then
      test_ipset_warning_found="Y"
      echo "------"
      echo "${test_ipset_warning}"
      echo "try to add ip into ipset banning list..."
      fail2ban-client set ${f2b_jail} banip ${test_ban_ip}
      sleep 2
      echo "------"
    fi

    # --- Second Check ---
    if [[ "${test_ipset_warning_found}" = "Y" ]]; then
      test_ipset_warning="$(test_ipset "${f2b_jail}" "${test_ban_ip}")"
      if [[ -n "${test_ipset_warning}" ]]; then
        echo "${test_ipset_warning}"
        echo "Firewalld is not running correctly!"
      else
        echo "ipset rules added !"
      fi
      echo ""
      echo ""
    fi
  done


  #fail2ban-client status | tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' |xargs -i bash -c "echo ---{}---; fail2ban-client set {} banip 10.255.255.254; echo"
}

check_fail2ban() {
  local diff_status_msg="$(test_fail2ban_config_status)"
  local test_ban_msg="$(test_ban)"
  if [[ -n "${diff_status_msg}" ]] || [[ -n "${test_ban_msg}" ]] ; then
    display_check_name

    echo -e "${diff_status_msg}"
    echo -e "${test_ban_msg}"
  fi
}
