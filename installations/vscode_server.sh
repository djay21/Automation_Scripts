
docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e PASSWORD=password \
  -e SUDO_PASSWORD=password \
  -e PROXY_DOMAIN=code-server.my.domain \
  -e DEFAULT_WORKSPACE=/config/workspace \
  -p 8443:8443 \
  -v /Users/deployer/code/config:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/code-server:latest