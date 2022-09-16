#!/bin/sh
/bin/01_user_config.sh
/bin/02_auto_update.sh
/bin/03_set_a2port.sh
/bin/04_enable_REMOTE_USER.sh
/bin/05_switch_http_https.sh
/bin/06_initialize_db.sh
/bin/07_set_prettyurls.sh
/bin/08_set_php.sh

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
