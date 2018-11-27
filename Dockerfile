FROM ubuntu:bionic

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
ENV supervisor_conf /etc/supervisor/supervisord.conf
ENV security_conf /etc/apache2/conf-available/security.conf
ENV start_scripts_path /bin

# Update packages from baseimage
RUN apt-get update -qq
# Install and activate necessary software
# Remark: Apache module mod_wsgi is installed but not enabled (anymore)
RUN apt-get upgrade -qy && apt-get install -qy \
    apt-utils \
    cron \
    supervisor \
    apache2 \
    apache2-utils \
    libexpat1 \
    ssl-cert \
    vim-tiny \
    php \
    libapache2-mod-php \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-pear \
    php-imagick \
    php-imap \
    php-memcache \
    php-pspell \
    php-recode \
    php-sqlite3 \
    php-tidy \
    php-xmlrpc \
    php-xsl \
    php-mbstring \
    php-gettext \
    php-opcache \
    php-apcu \
    wget \
    unzip \
    && a2enmod ssl \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2dissite 000-default \
    && mkdir /crt \
    && chmod 750 /crt \
    && openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /crt/webtrees.key -out /crt/webtrees.crt -subj "/C=DE/ST=H/L=F/O=Webtrees/OU=www.webtrees.net/CN=webtrees" \ 
    && chmod 640 /crt/* \
    && wget -q https://github.com/fisharebest/webtrees/releases/download/1.7.10/webtrees-1.7.10.zip -O /tmp/webtrees.zip \
    && unzip -d /tmp/ -o /tmp/webtrees.zip \
    && rm -Rf /var/www/html \
    && mv /tmp/webtrees /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 770 /var/www/html \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /tmp/* \
    && groupadd docker-data \
    && usermod -a -G docker-data,adm www-data

COPY supervisord.conf ${supervisor_conf}
COPY security.conf ${security_conf}
COPY 01_user_config.sh ${start_scripts_path}
COPY 02_auto_update.sh ${start_scripts_path}
COPY 03_set_a2port.sh ${start_scripts_path}
COPY 04_enable_REMOTE_USER.sh ${start_scripts_path}
COPY start.sh /start.sh
RUN chmod +x ${start_scripts_path}/01_user_config.sh \
    && chmod +x ${start_scripts_path}/02_auto_update.sh \
    && chmod +x ${start_scripts_path}/03_set_a2port.sh \
    && chmod +x ${start_scripts_path}/04_enable_REMOTE_USER.sh \
    && chmod +x /start.sh

CMD ["./start.sh"]

ADD Auth.php /Auth.php
       
#Add Apache configuration
ADD php.ini /etc/php/7.2/apache2/
ADD webtrees.conf /etc/apache2/sites-available/

RUN chmod 644 /etc/apache2/sites-available/webtrees.conf \
    && a2dissite 000-default \
    && a2enmod ssl \
    && a2ensite webtrees

VOLUME /var/www/html/data /var/www/html/media

EXPOSE 443/tcp
