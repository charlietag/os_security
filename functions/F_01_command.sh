COMMANDS=(chfn chsh login ls passwd ps top netstat ifconfig killall pidof find)
for com in ${COMMANDS[@]}
do
  COMM="$(which $com)"
  echo "===${COMM}==="
  BUS="$(rpm -Vf $COMM 2>&1)"
  if [ -z "${BUGS}" ]
  then
    echo "PASS"
  else
    echo "Command \"${COMM}\" is hacked"
  fi
  echo ""
done
