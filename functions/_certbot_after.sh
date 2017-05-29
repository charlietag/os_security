echo "-----Displaying current certificates-----"
$certbot_command certificates

echo "-----disable httpd server...-----"
systemctl disable httpd
systemctl stop httpd

