#!/bin/bash
A2HTTPPORT=${HTTP_PORT:-80}
A2HTTPSPORT=${HTTPS_PORT:-443}
echo "Listen *:$A2HTTPPORT" > /etc/apache2/p1.conf
echo "Listen *:$A2HTTPSPORT" > /etc/apache2/p2.conf
cat /etc/apache2/p1.conf /etc/apache2/p2.conf > /etc/apache2/ports.conf
rm /etc/apache2/p1.conf
rm /etc/apache2/p2.conf
