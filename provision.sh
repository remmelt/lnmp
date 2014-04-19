#! /usr/bin/env bash

umount /usr/share/nginx/html
aptitude update
aptitude safe-upgrade -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
aptitude install -y nginx mysql-server php5-mysql php5-common php5-cli php5-fpm git unzip htop zsh

cat << EOF > /etc/nginx/sites-enabled/default
# You may add here your
# server {
# ...
# }
# statements for each of your virtual hosts to this file

##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

server {
  listen 80 default_server;
  listen [::]:80 default_server ipv6only=on;

  root /usr/share/nginx/html;
  index index.html index.htm;

  # Make site accessible from http://localhost/
  server_name localhost;

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    try_files $uri $uri/ =404;
    # Uncomment to enable naxsi on this location
    # include /etc/nginx/naxsi.rules
  }

  # Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
  #location /RequestDenied {
  # proxy_pass http://127.0.0.1:8080;
  #}

  #error_page 404 /404.html;

  # redirect server error pages to the static page /50x.html
  #
  #error_page 500 502 503 504 /50x.html;
  #location = /50x.html {
  # root /usr/share/nginx/html;
  #}

  # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
  #
  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
  # # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
  #
  # # With php5-cgi alone:
  # fastcgi_pass 127.0.0.1:9000;
  # # With php5-fpm:
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  #
  #location ~ /\.ht {
  # deny all;
  #}
}


# another virtual host using mix of IP-, name-, and port-based configuration
#
#server {
# listen 8000;
# listen somename:8080;
# server_name somename alias another.alias;
# root html;
# index index.html index.htm;
#
# location / {
#   try_files $uri $uri/ =404;
# }
#}


# HTTPS server
#
#server {
# listen 443;
# server_name localhost;
#
# root html;
# index index.html index.htm;
#
# ssl on;
# ssl_certificate cert.pem;
# ssl_certificate_key cert.key;
#
# ssl_session_timeout 5m;
#
# ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
# ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
# ssl_prefer_server_ciphers on;
#
# location / {
#   try_files $uri $uri/ =404;
# }
#}
EOF

mount -t vboxsf -o uid=1000,gid=1000 /usr/share/nginx/html /usr/share/nginx/html
service php5-fpm restart
service nginx restart
