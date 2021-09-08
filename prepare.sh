#!/bin/bash

# set ip of app server
if [ "$#" -eq  "0" ]
  then
    echo "No arguments supplied. App domain name is not set."
else
    echo "Hello world"
    sed -i -e "s/your.domain.name/$1/g" ./docker-compose.yml
fi

# config docker registry mirrors to make pulling faster
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
