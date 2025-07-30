#!/bin/bash

git pull

echo "Updating stackui..."
cd "${CURRENT_DIR}/stackui"
sudo docker compose down
sudo docker compose up --build --force-recreate -d

echo "Updating nginx..."
cd "${CURRENT_DIR}/nginx"
sudo docker compose down
sudo docker compose up --build --force-recreate -d