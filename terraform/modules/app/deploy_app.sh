#!/bin/bash

set -e
export APP_DIR=$HOME
#export IP_DB=${module.db.external_ip_address_db}
#sleep 10
while [ -n "$(pgrep apt-get)" ]; do sleep 1; i=$((i+1)); echo $i ; done
sudo apt-get install -y git --allow-unauthenticated
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
