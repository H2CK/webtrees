#!/bin/bash
USE_REMOTE_USER=${ENABLE_REMOTE_USER:-FALSE}
if [ "$USE_REMOTE_USER" == "TRUE"]
then
copy -f /Auth.php /var/www/html/app/Auth.php
fi
