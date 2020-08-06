#!/usr/bin/env bash

[ "$DEBUG" = "true" ] && set -x


# Configure Sendmail if required
if [ "$ENABLE_SENDMAIL" == "true" ]; then
    /etc/init.d/sendmail start
fi

# Configure Xdebug
if [ "$XDEBUG_CONFIG" ]; then
    echo "" > /usr/local/etc/php/conf.d/zz-xdebug.ini
    for config in $XDEBUG_CONFIG; do
        echo "xdebug.$config" >> /usr/local/etc/php/conf.d/zz-xdebug.ini
    done
fi

if [ $(/etc/init.d/cron status | grep failed | wc -l) -gt 0 ]; then /etc/init.d/cron start; fi

# Execute the supplied command
exec "$@"
