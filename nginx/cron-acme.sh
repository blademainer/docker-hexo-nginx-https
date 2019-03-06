#!/usr/bin/env bash

echo "DOMAIN: $DOMAIN"
echo "DNS_TYPE: $DNS_TYPE"

/etc/running.env

echo "cron... env: `env`"

CERT_FILE="/nginx/ssl/${DOMAIN}.cer"
FULLCHAIN_FILE="/nginx/ssl/${DOMAIN}-fullchain.cer"
KEY_FILE="/nginx/ssl/${DOMAIN}.key"

#~/.acme.sh/acme.sh --issue --dns ${DNS_TYPE} -d $DOMAIN $RUNNING_ARGS $@
~/.acme.sh/acme.sh --issue --webroot /nginx/html -d $DOMAIN $RUNNING_ARGS $@

cp ~/.acme.sh/$DOMAIN/fullchain.cer $FULLCHAIN_FILE
cp ~/.acme.sh/$DOMAIN/$DOMAIN.key $KEY_FILE
echo "cer files: `ls /nginx/ssl/`"
nginx -s force-reload
