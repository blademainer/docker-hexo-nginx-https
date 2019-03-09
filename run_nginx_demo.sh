#!/usr/bin/env bash
# Your domains
DOMAIN="xiongyingqi.com blog.xiongyingqi.com"

# Generate ssh(just for demo).
ssh-keygen -f blog_ssh -q -N ""

# Your ssh public key(multiple).
AUTHORIZED_KEYS="`cat blog_ssh.pub`"

echo "your private key is: `cat blog_ssh`"

docker run -d --name blog --restart always -p 122:22 -p 80:80 -p 443:443 -e DOMAIN="$DOMAIN" -v `pwd`/html:/nginx/html -v `pwd`/acme_ssl:/nginx/ssl/ -e "AUTHORIZED_KEYS=$AUTHORIZED_KEYS" blademainer/hexo-nginx-https:v0.0.8

