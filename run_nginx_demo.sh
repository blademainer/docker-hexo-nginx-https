#!/usr/bin/env bash
# Domain
DOMAIN="xiongyingqi.com"

# RSA pubkey
AUTHORIZED_KEYS="xxx"

# type of dns. see: https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md
DNS_TYPE="dns_dp"
DP_Id="xxx"
DP_Key="xxx"

docker run -d --name blog --restart always -p 122:22 -p 443:443 -e "DOMAIN=$DOMAIN" -v `pwd`/html:/nginx/html -v `pwd`/acme_ssl:/root/.acme.sh/$DOMAIN -e "AUTHORIZED_KEYS=$AUTHORIZED_KEYS" -e DNS_TYPE=$DNS_TYPE -e DP_Id=$DP_Id -e DP_Key=$DP_Key blademainer/hexo-nginx-https:v0.0.4
#DOMAIN="ss.xiongyingqi.com"
#docker run --rm -p 122:22 -p 443:443 -e "DOMAIN=$DOMAIN" -v `pwd`/acme_ssl:/root/.acme.sh/$DOMAIN -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" -e DNS_TYPE=dns_dp -e DP_Id=xxx -e DP_Key=xxx blademainer/hexo-nginx-https
