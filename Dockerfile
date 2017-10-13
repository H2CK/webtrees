FROM phusion/baseimage:latest

# Set correct environment variables
ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

ADD setup.sh /tmp/
RUN bash /tmp/setup.sh
       
#Add Apache configuration
ADD php.ini /etc/php/7.0/apache2/
ADD webtrees.conf /etc/apache2/sites-available/
RUN chmod 644 /etc/apache2/sites-available/webtrees.conf \
    && a2dissite 000-default \
    && a2enmod ssl \
    && a2ensite webtrees

VOLUME /var/www/html/data /var/www/html/media

EXPOSE 443/tcp
