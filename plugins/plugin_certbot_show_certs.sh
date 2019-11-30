echo "-----Displaying current certificates-----"
$certbot_command certificates

echo "-----disable httpd server...-----"
systemctl disable httpd
systemctl stop httpd

#echo "-----restart nginx server to load SSL Cert files...-----"
#systemctl stop nginx ; sleep 3 ; systemctl start nginx
#
#echo "----- Finished restarting nginx server-----"
