check_whoisonline() {
  local who_is_online="$(/bin/who)"
  if [[ -n "${who_is_online}" ]]; then
    display_check_name
    echo -e "${who_is_online}"
  fi
}
