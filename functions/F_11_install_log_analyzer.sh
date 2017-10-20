# ***************************
# logwatch
# ***************************
yum install -y logwatch

# ***************************
# logwatch
# ***************************
yum install -y goaccess

# ***************************
# Postfix log parse
# ref. http://www.postfix.org/addon.html#logfile
# ***************************
yum install -y postfix-perl-scripts
sed -i /pflogsumm/d /etc/crontab
echo "01 01 * * * root /usr/sbin/pflogsumm -d yesterday /var/log/maillog" >> /etc/crontab

# ***************************
# setup config
# ***************************
echo "========================================="
echo "  Setup configs"
echo "========================================="
local log_analyzer_confs=($(find ${CONFIG_FOLDER} -type f))
local log_analyzer_target=""
local log_analyzer_target_folder=""
for log_analyzer_conf in ${log_analyzer_confs[@]}
do
  log_analyzer_target="${log_analyzer_conf/${CONFIG_FOLDER}/}"
  log_analyzer_target_folder="$(dirname $log_analyzer_target)"

  test -d $log_analyzer_target_folder || mkdir -p $log_analyzer_target_folder
  echo "Setting up config file \"${log_analyzer_target}\"......"
  \cp -a --backup=t $log_analyzer_conf $log_analyzer_target
done
