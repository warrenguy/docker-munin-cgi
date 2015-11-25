# Munin server for Docker

A Munin server for Docker using nginx and CGI.

## Usage

Clone the repository, build the Dockerfile, and then run the container,
specifying nodes to monitor in the NODES variable.

```
cd docker-munin-cgi
docker build -t munin-server
docker run \
  -p 10081:8080 \
  -e NODES="name:host name:host"
  --name munin-server \
  --restart always \
  --volume /storage/munin-server/var/lib/munin:/var/lib/munin \
  --volume /storage/munin-server/var/log/munin:/var/log/munin \
  munin-server
```
