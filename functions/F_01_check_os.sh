# =====================
# Enable databag
# =====================
# RENDER_CP

for os_command in ${os_commands[@]}
do
  COMM="$(which $os_command)"
  echo "===${COMM}==="
  BUGS="$(rpm -Vf $COMM)"
  if [ -z "${BUGS}" ]
  then
    echo "PASS"
  else
    echo "Command \"${COMM}\" is hacked"
    echo "${BUGS}"
  fi
  echo ""
done
