# =====================
# Enable databag
# =====================
# RENDER_CP

#--------------------------------------
# Rendering ssl_nginx config
#--------------------------------------
echo "========================================="
echo "  Rendering ssl_nginx configuration"
echo "========================================="
local ssl_nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local ssl_nginx_target=""
local ssl_nginx_target_folder=""
for ssl_nginx_conf in ${ssl_nginx_confs[@]}
do
  ssl_nginx_target="${ssl_nginx_conf/${CONFIG_FOLDER}/}"
  ssl_nginx_target_folder="$(dirname $ssl_nginx_target)"

  test -d $ssl_nginx_target_folder || mkdir -p $ssl_nginx_target_folder

  # ********* Only Render conf.d/*.conf ********
  if [ "$(basename $ssl_nginx_target_folder)" = "conf.d" ]
  then
    if [ "${sample_config_file}" = $(basename $ssl_nginx_target) ]
    then
      # use RENDER_CP to fetch var from datadog
      # not just render to destination, and rename destination filename to server_name
      local ssl_render_target_file="${ssl_nginx_target_folder}/${server_name}.conf"
      \cp -a --backup=t $ssl_nginx_conf $ssl_render_target_file
      RENDER_CP $ssl_nginx_conf $ssl_render_target_file
    fi

  else
    echo "Setting up config file \"${ssl_nginx_target}\"......"
    \cp -a --backup=t $ssl_nginx_conf $ssl_nginx_target
  fi

  # ********* Only Render  ********
  if [ "$(basename $ssl_nginx_target_folder)" = "ssl_dhparam" ]
  then
    local ssl_dhparam_file="${ssl_nginx_target_folder}/dhparam2048.pem"
    test -f $ssl_dhparam_file || $(which openssl) dhparam -out  2048
  fi
done

