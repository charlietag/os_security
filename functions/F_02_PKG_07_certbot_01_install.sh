#**********************************************
# =====================
# Enable databag
# =====================
# RENDER_CP

# Init action
. ${HELPERS}/plugin_certbot_path.sh
#**********************************************

# ******* Download certbot *******
if [ -d $certbot_path ]
then
  rm -fr $certbot_path
  rm -fr $certbot_root/eff.org
fi

echo "---Downloading CERTBOT---"
cd $certbot_root
git clone $certbot_src_url

echo "disable httpd server..."
systemctl disable httpd
systemctl stop httpd

# ******* Check certbot, determine if git clone success*******
echo "---Determining git status of CERTBOT---"
echo "change dir to \"${certbot_path}\""
cd $certbot_path
local git_ret_certbot="$(git pull | grep 'Already up-to-date')"
if [ -z "${git_ret_certbot}" ]
then
  echo "Git clone of certbot is FAILED !..."
  echo "Please try to reinstall certbot!..."
  git status
  exit 1
fi
echo "${git_ret_certbot}"

# ******* Install certbot renew script *******
echo "========================================="
echo "   Install certbot renew script"
echo "========================================="
task_copy_using_cat

local certbot_renew_script="/opt/certbot_scripts/certbot-auto_renew"
chmod 755 $certbot_renew_script

# *********************************
# Adding certificates renewal into crontab
# *********************************
echo "Adding cert renewal into crontab..."
sed -i /certbot-auto_renew/d /etc/crontab
echo "1 3 * * * root ${certbot_renew_script}" >> /etc/crontab

