#!/bin/bash

NODES=${NODES:-}

echo "Preparing munin config..."

mkdir -p /etc/munin/munin-conf.d
touch /etc/munin/munin-conf.d/nodes

for NODE in $NODES
do
  NAME=`echo $NODE | cut -d ":" -f1`
  HOST=`echo $NODE | cut -d ":" -f2`
  if ! grep -q $HOST /etc/munin/munin-conf.d/nodes ; then
    cat << EOF >> /etc/munin/munin-conf.d/nodes
[$NAME]
    address $HOST
    use_node_name yes

EOF
    fi
done

if [ ! -f /var/lib/munin/datafile.storable ]; then
  echo Running for the first time...
  echo    Fixing permissions on munin dirs...
  chown -Rf munin /var/lib/munin
  chown -Rf munin /var/log/munin

  echo    First run of munin-cron...
  sudo -u munin munin-cron
fi

echo Starting cron
cron

echo Starting fcgi backends...
/etc/init.d/spawn-fcgi-munin-html start
/etc/init.d/spawn-fcgi-munin-graph start

echo Starting nginx...
mkdir -p /var/cache/nginx
service nginx start

echo "Done!"

tail -F /var/log/syslog /var/log/nginx/* /var/log/munin/*
