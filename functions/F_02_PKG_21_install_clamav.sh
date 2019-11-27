# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# =====================
sed -i /clamav_clamscan.sh/d /etc/crontab
if [[ "${clamav_installation}" = "enable" ]]; then
  echo "========================================="
  echo "   Install clamav"
  echo "========================================="
  rpm --quiet -q clamav || yum install -y clamav

  echo "========================================="
  echo "   Setup clamav"
  echo "========================================="
  task_copy_using_render_sed

  local cron_clamav_script="/opt/clamav_script/clamav_clamscan.sh"
  chmod 755 ${cron_clamav_script}
  # *********************************
  # Script into crontab
  # *********************************
  echo "========================================="
  echo "   Setup cron for clamav_clamscan.sh"
  echo "========================================="
  echo "Adding script into crontab..."
  # sed -i /clamav_clamscan.sh/d /etc/crontab
  echo "1 5 * * * root ${cron_clamav_script}" >> /etc/crontab
fi

