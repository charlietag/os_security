# ******* Setup Nginx scripts *******
echo "========================================="
echo "Setup Nginx scripts"
echo "========================================="
task_copy_helper_view_using_render_sed

chmod 755 /opt/nginx_scripts/*.sh

# *********************************
# Adding nginx scripts into crontab
# *********************************
echo "Adding nginx related update scripts into crontab..."
sed -i /cron_ngx_modules_updates/d /etc/crontab
echo "1 2 * * * root /opt/nginx_scripts/cron_ngx_modules_updates.sh" >> /etc/crontab

