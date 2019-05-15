# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ssh failed login check
echo "-----------------------"
echo "check via ssh log file"
echo "-----------------------"
cat $ssh_log_file | grep "Failed" |grep    "invalid"  | awk '{print $11}' | sort  |uniq -c
cat $ssh_log_file | grep "Failed" |grep -v "invalid"  | awk '{print $9}'  | sort  |uniq -c

echo "-----------------------"
echo "check via command lastb"
echo "-----------------------"
lastb
