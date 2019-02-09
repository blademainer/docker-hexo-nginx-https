#!/usr/bin/env bash
name="manager-nginx"
[[ -n "`docker ps -f name=$name | grep $name`" ]] && echo "$name is running!" && exit -1

export curDir="`dirname $0`"
export fullDir="`pwd`/$curDir"
echo "fullDir===$fullDir"
echo "curDir=$curDir"

docker run --restart always --name $name -p 443:443 \
 -v $fullDir/nginx/nginx.conf:/etc/nginx/nginx.conf \
 -v $fullDir/nginx/conf.d:/etc/nginx/conf.d \
 -v $fullDir/nginx/html:/usr/share/nginx/html \
 -v $fullDir/nginx/ssl:/nginx/ssl \
 -v /etc/localtime:/etc/localtime:ro \
 -d nginx
