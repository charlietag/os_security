COMMANDS=(chfn chsh login ls passwd ps top netstat ifconfig killall pidof find)
for com in ${COMMANDS[@]}
do
  COMM="$(which $com)"
  echo "===${COMM}==="
  rpm -Vf $COMM
  echo ""
done
