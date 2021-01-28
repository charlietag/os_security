#if [ ! -f "$certbot_command" ]
if ! $(command -v  "$certbot_command" > /dev/null); then
  echo "${certbot_command} does not exists....!!"
  exit 1
fi

