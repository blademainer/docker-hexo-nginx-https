#!/usr/bin/env bash
echo "env: `env`"

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

/usr/sbin/sshd
/bin/cron-acme.sh

chown -R git:git /nginx/html

nginx -g "daemon off;"
