#!/bin/bash

systemctl enable --now docker

docker pull ghcr.io/benc-uk/nodejs-demoapp:4.9.9

docker run -d --name nodejs-demo --restart unless-stopped -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:latest
