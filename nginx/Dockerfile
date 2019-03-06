FROM nginx:latest

RUN apt-get update && apt-get -y install cron curl wget vim \
 && apt-get install -y git && adduser git && mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys \
 && apt-get install -y openssh-server && mkdir /var/run/sshd \
 && cd /tmp && curl https://get.acme.sh | sh \
 && mkdir -p /nginx/html

ENV DOMAIN="xiongyingqi.com"
ENV ACME_RUNNING_ARGS=""

ADD docker-entrypoint.sh /bin
ADD cron-acme.sh /bin
#ADD crontab /etc/cron.d/acme-cron
ADD running.env /etc
ADD conf.d/*.conf /etc/nginx/conf.d/
COPY sshd_config /etc/ssh/sshd_config

RUN chmod +x /bin/*.sh && chmod +x /etc/running.env

RUN mkdir -p /nginx/ssl/ && chmod 777 /nginx/html \
 && git init --bare /home/git/blog.git && chown -R git:git /home/git && chown -R git:git /nginx/html && chmod -R ug+rwX /home/git  \
 && echo "git --work-tree=/nginx/html --git-dir=/home/git/blog.git checkout -f" > /home/git/blog.git/hooks/post-receive \
 && chmod +x /home/git/blog.git/hooks/post-receive


WORKDIR /nginx/html

EXPOSE 443 22

ENTRYPOINT ["sh", "/bin/docker-entrypoint.sh"]
#CMD ["nginx", "-g", "daemon off;"]
