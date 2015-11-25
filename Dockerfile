FROM ubuntu:14.04

MAINTAINER Warren Guy <warren@guy.net.au>

RUN adduser --system --home /var/lib/munin --shell /bin/false --uid 1103 --group munin

RUN apt-get update -qq && RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive \
    apt-get install -y -qq cron munin munin-node nginx  wget heirloom-mailx spawn-fcgi libcgi-fast-perl
RUN rm /etc/nginx/sites-enabled/default && mkdir -p /var/cache/munin/www && chown munin:munin /var/cache/munin/www && mkdir -p /var/run/munin && chown -R munin:munin /var/run/munin

RUN apt-get clean

VOLUME /var/lib/munin
VOLUME /var/log/munin

ADD ./munin.conf /etc/munin/munin.conf
ADD ./nginx.conf /etc/nginx/sites-enabled/munin
ADD ./start-munin.sh /munin
ADD ./spawn-fcgi-munin-html /etc/init.d/spawn-fcgi-munin-html
ADD ./spawn-fcgi-munin-graph /etc/init.d/spawn-fcgi-munin-graph

EXPOSE 8080
CMD bash /munin
