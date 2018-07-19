task_copy_using_cat

echo "-------------------------------------------------------------"
echo "Generating openssl dhparam."
echo "This might take \"several minutes!\""
echo "Base on your server spec. This might take even \"up to hours\"...!"
echo "-------------------------------------------------------------"
local ssl_dhparam_file="/etc/nginx/ssl_dhparam/dhparam2048.pem"
test -f $ssl_dhparam_file || $(which openssl) dhparam -out $ssl_dhparam_file 2048
