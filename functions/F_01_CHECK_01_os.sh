# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

for os_command in ${os_commands[@]}
do
  local command_dir="$(which $os_command)"
  echo "===${command_dir}==="
  check_result="$(rpm -Vf $command_dir)"
  if [ -z "${check_result}" ]
  then
    echo "PASS"
  else
    echo "Command \"${command_dir}\" is hacked"
    echo "${check_result}"
  fi
  echo ""
done
