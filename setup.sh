#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

groupadd docker-data 
usermod -a -G docker-data,adm www-data

# user config
cat <<'EOT' > /etc/my_init.d/01_user_config.sh
#!/bin/bash
GROUPID=${GROUP_ID:-999}
groupmod -g $GROUPID docker-data 
EOT

# auto update
cat <<'EOT' > /etc/my_init.d/02_auto_update.sh
#!/bin/bash
apt-get update -qq
apt-get upgrade -qy
EOT

#set Port for Apache to listen to
cat <<'EOT' > /etc/my_init.d/03_set_a2port.sh
#!/bin/bash
A2PORT=${PORT:-443}
echo "Listen *:$A2PORT" > /etc/apache2/ports.conf
EOT

# Apache Startup Script
mkdir -p /etc/service/apache2
cat <<'EOT' > /etc/service/apache2/run
#!/bin/bash
exec /sbin/setuser root /usr/sbin/apache2ctl -DFOREGROUND 2>&1
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

apt-get update -qq
apt-get upgrade -qy
apt-get install -qy \
    apache2 \
    apache2-utils \
    libexpat1 \
    ssl-cert \
    php7.0 libapache2-mod-php7.0 \
    php7.0-mysql php7.0-curl php7.0-gd php7.0-intl php-pear php-imagick php7.0-imap php7.0-mcrypt php-memcache php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-mbstring php-gettext \
    php7.0-opcache php-apcu \
    wget \
    unzip 

mkdir /crt
chmod 750 /crt
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /crt/webtrees.key -out /crt/webtrees.crt -subj "/C=/ST=/L=/O=Webtrees/OU=www.webtrees.net/CN=webtrees" 
chmod 640 /crt/*

wget -q https://github.com/fisharebest/webtrees/releases/download/1.7.9/webtrees-1.7.9.zip -O /tmp/webtrees.zip
unzip -d /tmp/ -o /tmp/webtrees.zip
rm -Rf /var/www/html
mv /tmp/webtrees /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 770 /var/www/html

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /tmp/*
