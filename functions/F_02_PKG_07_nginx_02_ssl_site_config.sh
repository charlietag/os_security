# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ------------------------------------
# Make sure apply action is currect.
[[ -z "${site_type}" ]] && eval "${SKIP_SCRIPT}"
[[ "${site_type}" = "disable" ]] && eval "${SKIP_SCRIPT}"
# ------------------------------------


# ***************************************************
# Server type                                       *
# * Rails:                                          *
#   [ssl-sample-rails.conf]                         *
# * PHP / Laravel:                                  *
#   [ssl-sample-php.conf]                           *
# ***************************************************
[[ "${site_type}" = "laravel" ]] && local sample_config_file="ssl-sample-php.conf"
[[ "${site_type}" = "rails" ]]   && local sample_config_file="ssl-sample-rails.conf"


#--------------------------------------
# Rendering ssl_nginx config
#--------------------------------------
echo "========================================="
echo "  Rendering ssl_nginx configuration"
echo "========================================="

# ---------- Define var ---------
#if [[ -z "${sample_config_file}" ]]; then
#  echo "\"sample_config_file\" is not defined !"
#  exit
#fi

if [[ "${sample_config_file}" = "ssl-sample-php.conf" ]]; then
  local ssl_sample_config="${CONFIG_FOLDER}/etc/nginx/laravel_sites/ssl-sample-php.conf"
fi

if [[ "${sample_config_file}" = "ssl-sample-rails.conf" ]]; then
  local ssl_sample_config="${CONFIG_FOLDER}/etc/nginx/rails_sites/ssl-sample-rails.conf"
fi


# ---------- Start to render config ---------
local ssl_nginx_target_folder="$(dirname "${ssl_sample_config/${CONFIG_FOLDER}/}")"

test -d $ssl_nginx_target_folder || mkdir -p $ssl_nginx_target_folder

local ssl_render_target_file="${ssl_nginx_target_folder}/${server_name}.conf"

RENDER_CP $ssl_sample_config $ssl_render_target_file

echo "-----reload nginx server to load SSL Config & Cert files...-----"
#systemctl reload nginx
nginx -s reload

echo "----- Finished reloading nginx server-----"
