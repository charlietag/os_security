test_fail2ban_config_status() {
  local test_ban_ip="${1}"
  local f2b_status="$(fail2ban-client status | tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n'|sort -n)"
  local f2b_config="$(cat /etc/fail2ban/jail.local /etc/fail2ban/jail.d/*.local |grep -E "\[[^[:space:]]+\]$" | grep -v "DEFAULT" | grep -vE "^#" | sed -re 's/^\[//g' | sed -re 's/\]$//g' | sort -n)"
#  local f2b_iptables="$(iptables -S | grep -Eo "f2b-[^[:space:]]+" | sed 's/f2b-//g' | sort -n )"
#  local f2b_ipset="$(ipset list | grep -Eo "f2b-[^[:space:]]+" | sed 's/f2b-//g' | sort -n )"

#  local diff_check="$(  diff <(echo "${f2b_status}") <(echo "${f2b_config}")    ; \
#                        diff <(echo "${f2b_status}") <(echo "${f2b_iptables}")  ; \
#                        diff <(echo "${f2b_status}") <(echo "${f2b_ipset}")  
#                    )"
  local f2b_nft="$(nft list ruleset |grep "${test_ban_ip}")"
  local diff_check="$(  diff <(echo "${f2b_status}") <(echo "${f2b_config}")    ; \
                        diff <(echo "${f2b_status}" | wc -l | xargs -i bash -c "echo '{} - 1'| bc " ) <(echo "${f2b_nft}" | wc -l)  
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

    #echo -e '----- iptables -S ---'
    #echo -e "${f2b_iptables}"
    #echo ""

    #echo -e '----- ipset list ---'
    #echo -e "${f2b_ipset}"

    echo -e '----- nft list ruleset ---'
    echo -e "${f2b_nft}"
    echo ""
  fi
}

# ----------
# err msg description:
# ipset err msg: "ipset v7.1: The set with the given name does not exist"
#     This means this is the first time to start fail2ban, which needs to be initialized.
#     This will be solved after first time run this script (fail2ban-client set {jail_name} banip 10.255.255.254)
#
# 20200525
# CentoOS 8 is using nft rules instead.
# ----------
test_f2b() {
  local f2b_ban_jail="${1}"
  local test_ban_ip="${2}"
  local f2b_list="$(fail2ban-client get ${f2b_ban_jail} banip | grep "${test_ban_ip}" )"
  
  [[ -z "${f2b_list}" ]] && echo -e "fail2ban \"${f2b_ban_jail}\":\t\t... WARNING"
}

test_ban() {
  local test_ban_ip="${1}"
  local f2b_jails="$(cat /etc/fail2ban/jail.local /etc/fail2ban/jail.d/*.local |grep -E "\[[^[:space:]]+\]$" | grep -v "DEFAULT" | grep -vE "^#" | sed -re 's/^\[//g' | sed -re 's/\]$//g' | sort -n )"
  local test_f2b_warning
  local test_f2b_warning_found

  # --- Check fail2ban by f2b jail names one by one ---
  for f2b_jail in ${f2b_jails[@]}; do
    test_f2b_warning_found="N"
    # --- First Check ---
    test_f2b_warning="$(test_f2b "${f2b_jail}" "${test_ban_ip}")"
    if [[ -n "${test_f2b_warning}" ]]; then
      test_f2b_warning_found="Y"
      echo "------"
      echo "${test_f2b_warning}"
      echo "try to add ip into fail2ban(${f2b_jail} banning list..."
      fail2ban-client set ${f2b_jail} banip ${test_ban_ip}
      sleep 2
      echo "------"
    fi

    # --- Second Check ---
    if [[ "${test_f2b_warning_found}" = "Y" ]]; then
      test_f2b_warning="$(test_f2b "${f2b_jail}" "${test_ban_ip}")"
      if [[ -n "${test_f2b_warning}" ]]; then
        echo "${test_f2b_warning}"
        echo "Firewalld is not running correctly!"
      else
        echo "fail2ban rules added (nft)!"
      fi
      echo ""
      echo ""
    fi
  done


  #fail2ban-client status | tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' |xargs -i bash -c "echo ---{}---; fail2ban-client set {} banip 10.255.255.254; echo"
}

check_fail2ban() {
  local test_ban_ip="10.255.255.254"
  local diff_status_msg="$(test_fail2ban_config_status ${test_ban_ip})"
  local test_ban_msg="$(test_ban ${test_ban_ip})"
  if [[ -n "${diff_status_msg}" ]] || [[ -n "${test_ban_msg}" ]] ; then
    display_check_name

    echo -e "${diff_status_msg}"
    echo -e "${test_ban_msg}"
  fi
}
