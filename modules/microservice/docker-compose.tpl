#!/bin/bash
exec > >(tee /dev/tty) 2>&1
set -x
apt update -y
apt install -y docker.io curl
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat <<EOL > /home/ubuntu/docker-compose.yml
version: '3'
services:
  encrypt:
    image: \${image}:\${tag}
    ports:
      - "8080:8080"
    environment:
      - PORT=8080

  jwt:
    image: \${image}:\${tag}
    ports:
      - "8081:8081"
      - "8082:8082"
    environment:
      - PORT=8081
      - JWT_SECRET=\${jwt_secret}
EOL

systemctl start docker
systemctl enable docker
cd /home/ubuntu
docker-compose up -d
