#!/bin/bash
# Sets some php variables:
# The maximum upload size as set in the environment variable
# MAX_UPLOAD_SIZE in php.ini (default: upload_max_filesize = 2M).
# The maximum post size as set in environment variable
# POST_MAX_SIZE in php.ini (default: post_max_size = 8M)

MAXUPLOADSIZE=${MAX_UPLOAD_SIZE:-2M}
POSTMAXSIZE=${POST_MAX_SIZE:-8M}

CONFIG_FILE=/etc/php/8.1/apache2/php.ini

echo "Set max_upload_size."
#Check if not yet set, if file exists, do nothing
if [ -f "$CONFIG_FILE" ]; then
    sed -i -r 's,upload_max_filesize[ ]*=[ ]*[a-zA-Z0-9:\/\.]*,upload_max_filesize = '"$MAXUPLOADSIZE"',g' "$CONFIG_FILE"
fi

echo "Set post_max_size."
#Check if not yet set, if file exists, do nothing
if [ -f "$CONFIG_FILE" ]; then
    sed -i -r 's,post_max_size[ ]*=[ ]*[a-zA-Z0-9:\/\.]*,post_max_size = '"$POSTMAXSIZE"',g' "$CONFIG_FILE"
fi

rm -f "$CONFIG_FILE-E"
rm -f "$CONFIG_FILE-r"
