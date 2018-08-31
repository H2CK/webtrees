#!/bin/bash
A2HTTPSPORT=${PORT:-443}
echo "Listen *:$A2HTTPSPORT" > /etc/apache2/ports.conf
