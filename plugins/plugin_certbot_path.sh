# ******* Define var *******
local certbot_root="/opt"
local certbot_path="${certbot_root}/certbot"
local certbot_command="${certbot_path}/certbot-auto"

# ******* Define for dns-cloudflare *******
local certbot_python_pip_command="${certbot_root}/eff.org/certbot/venv/bin/pip"
local certbot_cf_path="${certbot_root}/certbot_dns_cloudflare"
local certbot_cf_ini="${certbot_root}/certbot_dns_cloudflare/cloudflare.ini"
