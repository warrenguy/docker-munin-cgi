```
docker run \
  -p 10081:8080 \
  -e NODES="node:node node:node"
  --name munin-server \
  --restart always \
  --volume /storage/munin-server/var/lib/munin:/var/lib/munin \
  --volume /storage/munin-server/var/log/munin:/var/log/munin \
  munin-server
```
