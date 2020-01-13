#!/bin/bash
A2HTTPSPORT=${PORT:-443}
HTTP_ONLY=${DISABLE_SSL:-FALSE}
if [ "$HTTP_ONLY" = "TRUE" ]
then
  PROTO="http"
else
  PROTO="https"
fi
echo "Listen *:$A2HTTPSPORT $PROTO" > /etc/apache2/ports.conf
