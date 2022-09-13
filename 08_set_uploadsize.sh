#!/bin/bash
# Sets the maximum upload size as set in the environment variable
# MAX_UPLOAD_SIZE in php.ini (default: upload_max_filesize = 2M).

MAXUPLOADSIZE=${MAX_UPLOAD_SIZE:-2M}


CONFIG_FILE=/etc/php/7.4/apache2/php.ini

echo "Set max_upload_size."
#Check if not yet set, if file exists, do nothing
if [ -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE found."
    sed -i -r 's,upload_max_filesize[ ]*=[ ]*[a-zA-Z0-9:\/\.]*,upload_max_filesize = '"$MAXUPLOADSIZE"',g' "$CONFIG_FILE"
fi

rm -f "$CONFIG_FILE-E"
rm -f "$CONFIG_FILE-r"
