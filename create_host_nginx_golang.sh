#!/bin/bash
# Fast way create virtual host for Ubuntu Nginx GoLang.
# 1) Don`t use symbol "_" for local domain name.
# 2) Open file `/etc/hosts` and string `#localhost` to the end of file (one-time step).
# 3) Run script under `root` user: `sudo -s;sh create_host_nginx_golang.sh <your-domain-name.local> <port>`

new_site_name=$1
new_site_port=$2
project_document_root="/var/www/html/$new_site_name"
nginx_site_available="/etc/nginx/sites-available/$new_site_name"
hosts_file="/etc/hosts"

echo "server {
	listen 80;
	listen [::]:80;
	root /var/www/html/$new_site_name;
	server_name $new_site_name;
	access_log /var/log/nginx/$new_site_name.access.log;
	error_log /var/log/nginx/$new_site_name.error.log;

	location / {
		proxy_pass http://$new_site_name:$new_site_port;
	}    		
}" > $nginx_site_available

mkdir $project_document_root
chmod 777 -R $project_document_root

ln -s $nginx_site_available /etc/nginx/sites-enabled/

sed -i "/\#localhost/a127.0.0.1 $new_site_name" $hosts_file

service nginx restart
