#!/bin/bash

# Atualizar pacotes
sudo apt-get update -y

# Instalar Docker
curl -fsSL https://get.docker.com/ | sh

# Instalar Docker Compose
sudo apt-get install -y docker-compose

# Criar o diretório /opt/pritunl com permissões adequadas
sudo mkdir -p /opt/pritunl

# Criar o arquivo docker-compose.yaml no diretório /opt/pritunl
sudo tee /opt/pritunl/docker-compose.yaml > /dev/null <<EOF
version: '3'
services:
  mongo:
    image: mongo:latest
    container_name: pritunldb
    hostname: pritunldb
    network_mode: bridge
    restart: always
    volumes:
      - ./db:/data/db

  pritunl:
    image: goofball222/pritunl:latest
    container_name: pritunl
    hostname: pritunl
    network_mode: bridge
    privileged: true
    restart: always
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0
    links:
      - mongo
    volumes:
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 443:443
      - 5050-5060:5050-5060/udp
      - 80:80
    environment:
      - TZ=America/Sao_Paulo
EOF

# Criar um arquivo de serviço systemd
sudo tee /etc/systemd/system/pritunl.service > /dev/null <<EOF
[Unit]
Description=Start Pritunl Docker Container
After=docker.service

[Service]
WorkingDirectory=/opt/pritunl
ExecStart=/usr/bin/docker compose -f /opt/pritunl/docker-compose.yaml up
ExecStop=/usr/bin/docker compose -f /opt/pritunl/docker-compose.yaml down
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Habilitar o serviço para iniciar na inicialização
sudo systemctl enable pritunl.service

# Reiniciar a instância para aplicar as mudanças
sudo reboot

#docker exec -it pritunl pritunl default-password