#!/bin/bash
USE_REMOTE_USER=${ENABLE_REMOTE_USER:-FALSE}
REMOTE_USER_VAR=${HEADER_AUTH_VAR:-REMOTE_USER}
if [ "$USE_REMOTE_USER" = "TRUE" ]
then
cp -f /Auth.php /var/www/html/app/Auth.php
sed -i 's/##REMOTE_USER##/'"$REMOTE_USER_VAR"'/g' /var/www/html/app/Auth.php
fi
