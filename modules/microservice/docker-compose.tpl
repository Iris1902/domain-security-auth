#!/bin/bash
exec > >(tee /dev/tty) 2>&1
set -x
apt update -y
apt install -y docker.io curl
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "JWT_SECRET=${jwt_secret}" > /home/ubuntu/.env

cat <<EOL > /home/ubuntu/docker-compose.yml
version: '3'
services:
  encrypt:
    image: ${image_encrypt}:${tag_encrypt}
    ports:
      - "${port_encrypt}:${port_encrypt}"
    environment:
      - PORT=${port_encrypt}

  jwt:
    image: ${image_jwt}:${tag_jwt}
    ports:
      - "${port_jwt}:${port_jwt}"
    environment:
      - PORT=${port_jwt}
    volumes:
      - /home/ubuntu/.env:/go/src/app/.env

  jwt-validate:
    image: ${image_jwt_validate}:${tag_jwt_validate}
    ports:
      - "${port_jwt_validate}:${port_jwt_validate}"
    environment:
      - PORT=${port_jwt_validate}
    volumes:
      - /home/ubuntu/.env:/go/src/app/.env
EOL

systemctl start docker
systemctl enable docker
cd /home/ubuntu
docker-compose up -d
