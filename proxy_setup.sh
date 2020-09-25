read -p "Enter the proxy address(like: http://proxy:8080/) : " proxy

sed -i "/^http/d" /etc/environment
sed -i "/^ftp/d" /etc/environment
sed -i "/^no_proxy/d" /etc/environment
sed -i "/^HTTP/d" /etc/environment


cat <<EOF >> /etc/environment
http_proxy=$proxy
https_proxy=$proxy
ftp_proxy=$proxy
no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
HTTP_PROXY=$proxy
HTTPS_PROXY=$proxy
EOF

rm -f ~/.docker/config.json
mkdir -p ~/.docker
cd ~/.docker 
cat <<EOF  >> config.json
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "$proxy",
     "httpsProxy": "$proxy"
    }
 }
}
EOF
rm -rf /etc/systemd/docker.service.d/
mkdir -p /etc/systemd/docker.service.d/
cd /etc/systemd/docker.service.d/   
cat  <<EOF  >> http-proxy.conf
 [Service]
  Environment="HTTP_PROXY=$proxy" Environment="NO_PROXY=localhost,127.0.0.1"
EOF
systemctl daemon-reload
systemctl restart docker


