#!/bin/bash -l
# ------------------ Define variables ------------------------------
THIS_FILE="$(readlink -m $0)"
THIS_FILE_LOCK="${THIS_FILE}.lock"


PRE_BANNED_LIST="${THIS_FILE}.banned_list"
[[ -f ${PRE_BANNED_LIST} ]] || touch ${PRE_BANNED_LIST}

#THIS_BANNED_CONTENTS="$(fail2ban-client status redmine | grep -i ip | awk -F':' '{print $2}' | sed 's/ /\n/g' | sed 's/\t//g' | sort -n | uniq)"

# not just redmine failed logged in.  all nginx related fail2ban rules have the same ipset & nginx keep alive issue
THIS_BANNED_CONTENTS="$(
                        fail2ban-client status | tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' | \
                        grep "nginx" |xargs -i bash -c "fail2ban-client status {} | grep -i ip | awk -F':' '{print \$2}'" | \
                        sed 's/ /\n/g' | sed 's/\t//g' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -n | uniq
                      )"

PRE_BANNED_CONTENTS="$(cat ${PRE_BANNED_LIST})"

DIFF_IP_ADD="$(diff <(echo -e "${PRE_BANNED_CONTENTS}") <(echo -e "${THIS_BANNED_CONTENTS}") | grep '>' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")"
DIFF_IP_SUBTRACT="$(diff <(echo -e "${PRE_BANNED_CONTENTS}") <(echo -e "${THIS_BANNED_CONTENTS}") | grep '<' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")"

THIS_PATH="$(dirname "${THIS_FILE}")"
# ------------------ Define variables ------------------------------


# ------------------ Lock Script ------------------------------
lock_process() {
  local lock_file="${THIS_FILE_LOCK}"
  local lock_file_pid lock_file_status
  [[ -f $lock_file ]] && lock_file_pid="$(cat ${lock_file} | grep -Eo "[[:digit:]]+")"
  [[ -n "${lock_file_pid}" ]] && lock_file_status="$(ps -p ${lock_file_pid} > /dev/null ; echo $?)"
  if [[ "${lock_file_status}" = "0" ]]; then
    echo "Process is running! (pid: ${lock_file_pid})"
    exit
  else
    #echo "Starting..."
    echo $$ > $lock_file
  fi
}
# ------------------ Lock Script ------------------------------

# ------------------ Main script ------------------------------
main() {
  if [[ -n "${DIFF_IP_ADD}" ]]; then
    echo "--- New banned IP found! ---"
    echo -e "${DIFF_IP_ADD}"

    echo "Reloading Nginx ..."

    nginx -s reload && echo -e "${THIS_BANNED_CONTENTS}" > ${PRE_BANNED_LIST}

  elif [[ -n "${DIFF_IP_SUBTRACT}" ]]; then
    echo "--- Banned IP expired ... ---"
    echo -e "${DIFF_IP_SUBTRACT}"
    echo -e "${THIS_BANNED_CONTENTS}" > ${PRE_BANNED_LIST}

  else
    #echo "Everything is OK ..."
    exit
  fi
}
# ------------------ Main script ------------------------------

lock_process
#sleep 50
#exit
main

