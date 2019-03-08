#!/usr/bin/env bash
# See: https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E#3-copy%E5%AE%89%E8%A3%85-%E8%AF%81%E4%B9%A6
echo "DOMAIN: $DOMAIN"
# echo "DNS_TYPE: $DNS_TYPE"
echo "$DOMAIN" | awk '{rs="";delimiter=" -d ";for(i=1;i<=NF;i++){rs=rs""delimiter""$i;};print rs}' > /etc/domains_args
DOMAIN_ARGS=`cat /etc/domains_args`

/etc/running.env

echo "cron... env: `env`"

CERT_FILE="/nginx/ssl/domain.cer"
FULLCHAIN_FILE="/nginx/ssl/fullchain.cer"
KEY_FILE="/nginx/ssl/domain.key"

#~/.acme.sh/acme.sh --issue --dns ${DNS_TYPE} -d $DOMAIN $RUNNING_ARGS $@
#~/.acme.sh/acme.sh --issue --webroot /nginx/html -d $DOMAIN $RUNNING_ARGS $@
# auto update certs.
# https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E#4-%E6%9B%B4%E6%96%B0%E8%AF%81%E4%B9%A6
~/.acme.sh/acme.sh --issue --webroot /nginx/html $DOMAIN_ARGS --installcert --key-file $KEY_FILE --fullchain-file $FULLCHAIN_FILE --reloadcmd  "service nginx force-reload" $RUNNING_ARGS $@

#cp ~/.acme.sh/$DOMAIN/fullchain.cer $FULLCHAIN_FILE
#cp ~/.acme.sh/$DOMAIN/$DOMAIN.key $KEY_FILE
echo "cer files: `ls /nginx/ssl/`"
nginx -s reload
