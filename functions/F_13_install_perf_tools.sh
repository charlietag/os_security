# ***************************
# glances
# ***************************
yum install -y glances

# ***************************
# iotop
# ***************************
yum install -y iotop

# ***************************
# mytop - mysql perf monitor
# ***************************
yum install -y mytop

# ***************************
# setup config
# ***************************
echo "========================================="
echo "  Setup configs"
echo "========================================="
local perf_tools_confs=($(find ${CONFIG_FOLDER} -type f))
local perf_tools_target=""
local perf_tools_target_folder=""
for perf_tools_conf in ${perf_tools_confs[@]}
do
  perf_tools_target="${perf_tools_conf/${CONFIG_FOLDER}/}"
  perf_tools_target_folder="$(dirname $perf_tools_target)"

  test -d $perf_tools_target_folder || mkdir -p $perf_tools_target_folder
  # use RENDER_CP to fetch var from datadog
  RENDER_CP $perf_tools_conf $perf_tools_target
done
