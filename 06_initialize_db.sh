#!/bin/bash
INIT_DB=${DB_PASSWORD:-FALSE}
IDB_TYPE=${DB_TYPE:-mysql}
IDB_HOST=${DB_HOST:-localhost}
IDB_PORT=${DB_PORT:-3306}
IDB_USER=${DB_USER:-root}

# Change default port and database user if using postgres
if [ "$IDB_TYPE" = "postgres" ]; then
    IDB_PORT=${DB_PORT:-5432}
    IDB_USER=${DB_USER:-postgres}
fi

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
        sed -i 's/<DB_TYPE>/'"$IDB_TYPE"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_HOST>/'"$IDB_HOST"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PORT>/'"$IDB_PORT"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_USER>/'"$IDB_USER"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PASSWORD>/'"$IDB_PASSWORD"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_NAME>/'"$IDB_DB_NAME"'/g' "$CONFIG_FILE"
        sed -i 's/<DB_PREFIX>/'"$IDB_DB_PREFIX"'/g' "$CONFIG_FILE"
        chown www-data:docker-data "$CONFIG_FILE"
        chmod 660 "$CONFIG_FILE"
        #Create database structure and add admin user
        if [ "$IDB_TYPE" = "postgres" ]; then
            SQL_FILE="/webtrees-postgres.sql"
        else
            SQL_FILE="/webtrees.sql"
        fi

        cp "$SQL_FILE" /mod_webtrees.sql
        sed -i 's/<DB_NAME>/'"$IDB_DB_NAME"'/g' /mod_webtrees.sql
        sed -i 's/<WT_ADMIN_NAME>/'"$IDB_WT_ADMIN"'/g' /mod_webtrees.sql

        #Encode password and escape for sed
        RANDOM22=$(php -r "echo substr(base64_encode(openssl_random_pseudo_bytes(17)),0,22);")
        WTSALT=$(php -r "echo '\$2y\$10\$'.str_replace('+','.','$RANDOM22');")
        WTCRYPT=$(php -r "echo crypt('$IDB_WT_ADMINPW', '$WTSALT');")
        sed -i 's/<WT_ADMIN_PW>/'"$(echo $WTCRYPT | sed -e 's/[]\/$*.^[]/\\&/g')"'/g' /mod_webtrees.sql
        sed -i 's/<WT_ADMIN_MAIL>/'"$IDB_WT_ADMINMAIL"'/g' /mod_webtrees.sql

        # Wait for database and write schema based on type
        if [ "$IDB_TYPE" = "postgres" ]; then
            echo "Using PostgreSQL database"
            until pg_isready -h "$IDB_HOST" -p "$IDB_PORT" -U "$IDB_USER" > /dev/null 2>&1; do
                echo "Waiting for PostgreSQL database to be ready ..."
                sleep 1
            done
            echo "PostgreSQL database ready. Writing database."
            export PGPASSWORD="$IDB_PASSWORD"
            psql -h "$IDB_HOST" -p "$IDB_PORT" -U "$IDB_USER" -d postgres -f /mod_webtrees.sql
            unset PGPASSWORD
        else
            echo "Using MySQL/MariaDB database"
            until mysqladmin ping -h "$IDB_HOST" --silent; do
                echo "Waiting for MySQL/MariaDB database to be ready ..."
                sleep 1
            done
            echo "MySQL/MariaDB database ready. Writing database."
            mysql -u "$IDB_USER" --password="$IDB_PASSWORD" -h "$IDB_HOST" < /mod_webtrees.sql
        fi

        unset RANDOM22
        unset WTSALT
        unset WTCRYPT
    fi
fi
