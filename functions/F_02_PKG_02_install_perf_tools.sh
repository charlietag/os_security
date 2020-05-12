# ***************************
# enhanced top
# ***************************
# glances does not exist in CentOS 8 (EPEL, base, AppStream)
#dnf install -y glances htop nmon
dnf install -y htop nmon

# ***************************
# enhaned iostat
# ***************************
# dstat does not exist in CentOS 8 (EPEL, base, AppStream)
#dnf install -y iotop dstat 
dnf install -y iotop


