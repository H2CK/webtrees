FROM ubuntu:20.04

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
ENV supervisor_conf /etc/supervisor/supervisord.conf
ENV security_conf /etc/apache2/conf-available/security.conf
ENV start_scripts_path /bin
ENV WT_VERSION="2.1.0-alpha.2"

# Install and activate necessary software
RUN apt-get update -qq && apt-get upgrade -qy && apt-get install -qy \
    apt-utils \
    software-properties-common \ 
    cron \
    supervisor \
    apache2 \
    apache2-utils \
    libexpat1 \
    ssl-cert \
    vim-tiny \
    wget \
    unzip \
    sed \
    mysql-client \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update -qq \
    && apt-get upgrade -qy \
    && apt-get install -qy \
    php8.1 \
    libapache2-mod-php8.1 \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-pdo-odbc \
    php8.1-curl \
    php8.1-gd \
    php8.1-intl \
    php8.1-imagick \
    php8.1-imap \
    php8.1-memcache \
    php8.1-pspell \
    php8.1-sqlite3 \
    php8.1-tidy \
    php8.1-xmlrpc \
    php8.1-xsl \
    php8.1-mbstring \
    php8.1-opcache \
    php8.1-apcu \
    php8.1-zip \
    && a2enmod ssl \
    && a2enmod headers \
    && a2enmod rewrite \
    && a2dissite 000-default \
    && mkdir /crt \
    && chmod 750 /crt \
    && openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /crt/webtrees.key -out /crt/webtrees.crt -subj "/C=DE/ST=H/L=F/O=Webtrees/OU=www.webtrees.net/CN=webtrees" \ 
    && chmod 640 /crt/* \
    && wget -q https://github.com/fisharebest/webtrees/releases/download/${WT_VERSION}/webtrees-${WT_VERSION}.zip -O /tmp/webtrees.zip \
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
COPY 05_switch_http_https.sh ${start_scripts_path}
COPY 07_set_prettyurls.sh ${start_scripts_path}
COPY 06_initialize_db.sh ${start_scripts_path}
COPY start.sh /start.sh
RUN chmod +x ${start_scripts_path}/01_user_config.sh \
    && chmod +x ${start_scripts_path}/02_auto_update.sh \
    && chmod +x ${start_scripts_path}/03_set_a2port.sh \
    && chmod +x ${start_scripts_path}/04_enable_REMOTE_USER.sh \
    && chmod +x ${start_scripts_path}/05_switch_http_https.sh \
    && chmod +x ${start_scripts_path}/07_set_prettyurls.sh \
    && chmod +x ${start_scripts_path}/06_initialize_db.sh \
    && chmod +x /start.sh

CMD ["./start.sh"]

ADD Auth.php /Auth.php
ADD config.ini.php /config.ini.php
ADD webtrees.sql /webtrees.sql
COPY .htaccess /var/www/html/.htaccess
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 770 /var/www/html
       
#Add Apache configuration
ADD php.ini /etc/php/8.1/apache2/
ADD webtrees.conf /etc/apache2/sites-available/
ADD webtrees_insecure.conf /etc/apache2/sites-available/

RUN chmod 644 /etc/apache2/sites-available/webtrees.conf \
    && chmod 644 /etc/apache2/sites-available/webtrees_insecure.conf \
    && a2dissite 000-default \
    && a2enmod ssl \
    && a2ensite webtrees

VOLUME /var/www/html/data

EXPOSE 443/tcp
