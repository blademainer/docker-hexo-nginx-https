#!/usr/bin/env bash
DOMAIN="ss.xiongyingqi.com"
docker run --rm -p 122:22 -p 443:443 -e "DOMAIN=$DOMAIN" -v `pwd`/acme_ssl:/root/.acme.sh/$DOMAIN -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" -e DNS_TYPE=dns_dp -e DP_Id=xxx -e DP_Key=xxx blademainer/hexo-nginx-https
