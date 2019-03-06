#!/usr/bin/env bash
echo "env: `env`"

export DOMAINS=`echo $DOMAIN | grep -E "^\w+(\.\w+)+(\s+\w+(\.\w+)+)*$"`
[ -z "$DOMAINS" ] && echo "DOMAIN format is: example.net www.example.net aaa.example.net" && exit 1

DEFAULT_TZ="Asia/Shanghai"
if [ -z "$TZ" ]; then
 export TZ="$DEFAULT_TZ"
fi
echo "TZ: $TZ"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

[ -z "$AUTHORIZED_KEYS" ] && echo "env: AUTHORIZED_KEYS is null! please present it!" && exit 1

DEFAULT_DNS_TYPE="dns_dp"
if [ -z "$DNS_TYPE" ]; then
 export DNS_TYPE="$DEFAULT_DNS_TYPE"
fi

echo "DNS_TYPE: $DNS_TYPE"

#case $DNS_TYPE in \
#  "dns_dp") \
#    [ -z "${DP_ID}" ] && "DP_ID is null!" && exit 1 \
#    [ -z "${DP_KEY}" ] && "DP_KEY is null!" && exit 1 \
#    ;; \
#  "dns_gd") \
#    [ -z "${GD_KEY}" ] && "GD_KEY is null!" && exit 1 \
#    [ -z "${GD_SECRET}" ] && "GD_SECRET is null!" && exit 1 \
#    ;; \
#esac


#if [ "$DNS_TYPE" == "dns_dp" ]; then
#  [ -z "${DP_Id}" ] && "DP_ID is null!" && exit 1
#  [ -z "${DP_Key}" ] && "DP_Key is null!" && exit 1
#elif [ "$DNS_TYPE" == "dns_gd" ]; then
#  [ -z "${GD_KEY}" ] && "GD_KEY is null!" && exit 1
#  [ -z "${GD_SECRET}" ] && "GD_SECRET is null!" && exit 1
#fi

echo $DOMAIN | awk '{rs="";delimiter="";for(i=1;i<=NF;i++){rs=rs""delimiter""$i;delimiter="\n"};print rs}' > /etc/domains

#echo "exec args: $@ len: $#"


#export RUNNING_ARGS="$@"
#ACME_RUNNING_ARGS=""

#sed -i "s~%RUNNING_ARGS%~$RUNNING_ARGS~g" /etc/running.env
sed -i "s~%DNS_TYPE%~$DNS_TYPE~g" /etc/running.env
sed -i "s~%DOMAIN%~$DOMAIN~g" /etc/running.env
sed -i "s~%DOMAIN%~$DOMAIN~g" /etc/nginx/conf.d/hexo.conf

echo "$AUTHORIZED_KEYS" >> /home/git/.ssh/authorized_keys
#exec $@
cron &

# https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E#5-%E6%9B%B4%E6%96%B0-acmesh
~/.acme.sh/acme.sh  --upgrade  --auto-upgrade

/usr/sbin/sshd
# auto update certs.
# https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E#4-%E6%9B%B4%E6%96%B0%E8%AF%81%E4%B9%A6
/bin/cron-acme.sh

#crontab /etc/cron.d/acme-cron

chown -R git:git /nginx/html

nginx -g "daemon off;"
