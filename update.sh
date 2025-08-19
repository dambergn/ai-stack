#!/bin/bash

CURRENT_DIR=$(pwd)

git_pull_current_branch() {
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git pull origin "$current_branch"
}

update_services() {
    echo "Updating stackui..."
    cd "${CURRENT_DIR}/stackui"
    sudo docker compose down
    sudo docker compose up --build --force-recreate -d

    echo "Updating nginx..."
    cd "${CURRENT_DIR}/nginx"
    sudo docker compose down
    sudo docker compose up --build --force-recreate -d

    echo "Updating ollama..."
    cd "${CURRENT_DIR}/ollama"
    sudo docker compose down
    sudo docker compose up --build --force-recreate -d

    echo "Updating open-webui..."
    cd "${CURRENT_DIR}/open-webui"
    sudo docker compose down
    sudo docker compose up --build --force-recreate -d
}




main(){
    git_pull_current_branch
    update_services
    docker image prune -a
}

main