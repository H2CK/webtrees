#!/bin/bash
INIT_DB=${DB_PASSWORD:-FALSE}
IDB_HOST=${DB_HOST:-localhost}
IDB_PORT=${DB_PORT:-3306}
IDB_USER=${DB_USER:-root}
IDB_PASSWORD=${DB_PASSWORD:-password}
IDB_DB_NAME=${DB_NAME:-webtrees}
IDB_DB_PREFIX="wt_"
IDB_WT_ADMIN=${WT_ADMIN:-admin}
IDB_WT_ADMINPW=${WT_ADMINPW:-admin123}
IDB_WT_ADMINMAIL=${WT_ADMINMAIL:-noreply@webtrees.net}

#Check if initial database configuration should be set
if [ "$INIT_DB" != "FALSE" ]
then
    #Check if not yet set, if file exists, do nothing
    CONFIG_FILE=/var/www/html/data/config.ini.php
    if [ -f "$CONFIG_FILE" ]; then
        echo "Configuration file $CONFIG_FILE yet exist. No settings will be modified."
    else
        echo "Creating the initial database settings in configuration file $CONFIG_FILE and creating database."
        cp /config.ini.php "$CONFIG_FILE"
        sed -i 's/<DB_HOST>/'"$IDB_HOST"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PORT>/'"$IDB_PORT"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_USER>/'"$IDB_USER"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PASSWORD>/'"$IDB_PASSWORD"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_NAME>/'"$IDB_DB_NAME"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PREFIX>/'"$IDB_DB_PREFIX"'/g' "$CONFIG_FILE"
        chown www-data:docker-data "$CONFIG_FILE"
        chmod 660 "$CONFIG_FILE"
        #Create database structure and add admin user
        cp /webtrees.sql /mod_webtrees.sql
        sed -i 's/<DB_NAME>/'"$IDB_DB_NAME"'/g' /mod_webtrees.sql
        sed -i 's/<WT_ADMIN_NAME>/'"$IDB_WT_ADMIN"'/g' /mod_webtrees.sql
        #Encode password and escape for sed
        WTCRYPT=$(php -r "echo crypt('$IDB_WT_ADMINPW', '');")
        sed -i 's/<WT_ADMIN_PW>/'"$(echo $WTCRYPT | sed -e 's/[]\/$*.^[]/\\&/g')"'/g' /mod_webtrees.sql
        sed -i 's/<WT_ADMIN_MAIL>/'"$IDB_WT_ADMINMAIL"'/g' /mod_webtrees.sql
        #Write to database
        mysql -u "$IDB_USER" --password="$IDB_PASSWORD" -h "$IDB_HOST" < /mod_webtrees.sql
        #Alternative to set Webtrees admin user:
        #echo "UPDATE wt_user SET user_name='$IDB_WT_ADMIN', email='$IDB_WT_ADMINMAIL', real_name='Admin', password='$WTCRYPT' WHERE user_id=1" | mysql -u "$IDB_USER" --password="$IDB_PASSWORD" -h "$IDB_HOST" "$IDB_DB_NAME"
    fi
fi
