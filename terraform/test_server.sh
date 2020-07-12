#!/usr/bin/env bash

echo "* hard nofile 102400" >> /etc/security/limits.conf
echo "* soft nofile 102400" >> /etc/security/limits.conf
sysctl -w fs.file-max=102400
sysctl -w net.ipv4.ip_local_port_range="1024 65535"
sysctl -w net.core.somaxconn=65535
sysctl -w net.core.netdev_max_backlog=10000
sysctl -p

# prereqs
yum install pcre-devel openssl-devel gcc curl htop -y

# add the repo:
wget https://openresty.org/package/amazon/openresty.repo
mv openresty.repo /etc/yum.repos.d/

# update the index:
yum check-update

# install openresty
yum install -y openresty

mkdir /usr/local/openresty/nginx/ssl

openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out /usr/local/openresty/nginx/ssl/example.com.crt \
            -keyout /usr/local/openresty/nginx/ssl/example.com.key \
	    -subj "/C=US/ST=NY/L=New York/O=Nginx/OU=server/CN=`hostname -f`/emailAddress=nico.piderman@gmail.com"


echo "
worker_processes auto; 
worker_rlimit_nofile 102400;

events {
  worker_connections  102400;
}

http {
  access_log off;
  error_log off;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;

	server {
		listen 443 ssl http2 default_server backlog=65535;
		listen [::]:443 ssl http2 default_server backlog=65535;

		root /var/www/html;

		index index.html index.htm index.nginx-debian.html;

		server_name example.com;

		location / {
       echo "Hello world!";
		}

		location /wait/10 {
		   echo_sleep 0.01;
       echo "Hello world!";
		}

		location /wait/100 {
		   echo_sleep 0.1;
       echo "Hello world!";
		}

		ssl_certificate /usr/local/openresty/nginx/ssl/example.com.crt;
		ssl_certificate_key /usr/local/openresty/nginx/ssl/example.com.key; 
	}


	server {
    keepalive_requests 100;
    keepalive_timeout 60;
    listen         80 backlog=65535;
    listen    [::]:80 backlog=65535;

		location / {
       echo "Hello world!";
		}

		location /wait/10 {
		   echo_sleep 0.01;
       echo "Hello world!";
		}

		location /wait/100 {
		   echo_sleep 0.1;
       echo "Hello world!";
		}
	}
}
" >  /usr/local/openresty/nginx/conf/nginx.conf

# start openresty
/usr/local/openresty/bin/openresty

