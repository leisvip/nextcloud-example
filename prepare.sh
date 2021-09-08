#!/bin/bash

# set ip of app server
if [ "$#" -eq  "0" ]
  then
    echo "No arguments supplied. App domain name is not set."
else
    echo "Hello world"
    sed -i -e "s/your.domain.name/$1/g" ./docker-compose.yml
fi
