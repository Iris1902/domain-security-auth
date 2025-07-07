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
    image: ievinan/microservice-encrypt:${tag}
    ports:
      - "8080:8080"
    environment:
      - PORT=8080

  jwt:
    image: ievinan/microservice-jwt:${tag}
    ports:
      - "8081:8081"
    environment:
      - PORT=8081
    volumes:
      - /home/ubuntu/.env:/go/src/app/.env

  jwt-validate:
    image: ievinan/microservice-jwt-validate:${tag}
    ports:
      - "8082:8082"
    environment:
      - PORT=8082
    volumes:
      - /home/ubuntu/.env:/go/src/app/.env
EOL

systemctl start docker
systemctl enable docker
cd /home/ubuntu
docker-compose up -d
