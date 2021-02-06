echo "-----Displaying current certificates-----"
$certbot_command certificates

echo "-----Be sure to disable httpd server...-----"
set -x
systemctl disable httpd
systemctl stop httpd
set +x

#echo "-----restart nginx server to load SSL Cert files...-----"
#systemctl stop nginx ; sleep 3 ; systemctl start nginx
#
#echo "----- Finished restarting nginx server-----"
