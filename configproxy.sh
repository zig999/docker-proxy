#!/bin/bash

function start_config {
read u p < /root/proxy_credentials

export HTTP_PROXY=http://$u:$p@proxy_weg.weg.net:8080
export HTTPS_PROXY=https://$u:$p@proxy_weg.weg.net:8080

/bin/cat <<EOF > /etc/apt/apt.conf 
Acquire::http::proxy "http://$u:$p@proxy_weg.weg.net:8080";
Acquire::https::proxy "https://$u:$p@proxy_weg.weg.net:8080";
EOF
}

if [ -s "/root/proxy_credentials" ]
then
start_config
fi