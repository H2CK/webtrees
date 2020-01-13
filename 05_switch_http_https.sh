#!/bin/bash
HTTP_ONLY=${DISABLE_SSL:-FALSE}
if [ "$HTTP_ONLY" = "TRUE" ]
then
cp -f /webtrees_insecure.conf /etc/apache2/
fi
