#!/bin/bash

DATE=$(date +"%Y-%m-%d-%H")
KEY=/home/ap1/.ssh/appuser.pub

yc compute instance create \
            --name reddit-app-full-$DATE \
            --hostname reddit-app-full-$DATE \
            --zone=ru-central1-a \
            --create-boot-disk size=20GB,image-id=fd8b12iglpvrid232tnc  \
            --cores=2   --memory=8G   --core-fraction=100 \
            --network-interface subnet-id=e9beas4djj8ian04bu5r,ipv4-address=auto,nat-ip-version=ipv4 \
            --ssh-key $KEY
