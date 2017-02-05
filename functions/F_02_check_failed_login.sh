# =====================
# Enable databag
# =====================
# RENDER_CP

# ssh failed login check
cat $ssh_log_file | grep "Failed" |grep    "invalid"  | awk '{print $11}' | sort  |uniq -c
cat $ssh_log_file | grep "Failed" |grep -v "invalid"  | awk '{print $9}'  | sort  |uniq -c
