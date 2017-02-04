COMMANDS=(chfn chsh login ls passwd ps top netstat ifconfig killall pidof find)
for com in ${COMMANDS[@]}
do
  COMM="$(which $com)"
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
