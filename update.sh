#!/bin/bash

echo "Updating stackui..."
cd "${CURRENT_DIR}/stackui"
sudo docker compose down
sudo docker compose up --build --force-recreate -d