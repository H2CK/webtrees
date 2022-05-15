#!/bin/bash
# Checks if pretty urls should be activated, when the environment variable
# PRETTYURLS is set to TRUE. Otherwise there will be no changes in config.ini.php.
#
# When setting PRETTYURLS to true it is also necessary to set BASE_URL. 

WT_BASE_URL=${BASE_URL:-FALSE}
WT_PRETTYURLS=${PRETTYURLS:-FALSE}

CONFIG_FILE=/var/www/html/data/config.ini.php

#Check if prettyurls should be set
if [ "$WT_PRETTYURLS" != "FALSE" ]
then
    echo "Activate pretty urls."
    #Check if not yet set, if file exists, do nothing
    if [ -f "$CONFIG_FILE" ]; then
        echo "Configuration file $CONFIG_FILE found."
        if grep -q "rewrite_urls" $CONFIG_FILE; then
            echo "Setting rewrite_urls=\"1\"."
            sed -i -r 's,rewrite_urls[ ]*=[ ]*\"[a-zA-Z0-9:\/\.]*\",rewrite_urls="1",g' "$CONFIG_FILE"
        else
            echo "Adding rewrite_urls=\"1\"."
            echo "rewrite_urls=\"1\"" >> $CONFIG_FILE
        fi
    else
        echo "Creating the configuration file $CONFIG_FILE and setting rewrite_urls."
        cp /config_blank.ini.php "$CONFIG_FILE"
        echo "Adding rewrite_urls=\"1\"."
        echo "rewrite_urls=\"1\"" >> $CONFIG_FILE
    fi
else
    echo "PRETTYURLS not explicitly activated. Nothing to do."
fi
#Check if baseurl should be set
if [ "$WT_BASE_URL" != "FALSE" ]
then
    echo "Set base_url in $CONFIG_FILE"
    #Check if not yet set, if file exists, do nothing
    if [ -f "$CONFIG_FILE" ]; then
        echo "Configuration file $CONFIG_FILE found."
        if grep -q "base_url" $CONFIG_FILE; then
            echo "Setting base_url=\"$WT_BASE_URL\"."
            sed -i -r 's,base_url[ ]*=[ ]*\"[a-zA-Z0-9:\/\.]*\",base_url="'"$WT_BASE_URL"'",g' "$CONFIG_FILE"
        else
            echo "Adding base_url=\"$WT_BASE_URL\"."
            echo "base_url=\"$WT_BASE_URL\"" >> $CONFIG_FILE
        fi
    else
        echo "Creating the configuration file $CONFIG_FILE and setting base_url."
        cp /config_blank.ini.php "$CONFIG_FILE"
        echo "Adding base_url=\"$WT_BASE_URL\"."
        echo "base_url=\"$WT_BASE_URL\"" >> $CONFIG_FILE
    fi
else
    echo "BASE_URL not explicitly set. Nothing to do."
fi
rm -f "$CONFIG_FILE-E"
rm -f "$CONFIG_FILE-r"
