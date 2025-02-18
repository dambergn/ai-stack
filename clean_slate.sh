#!/bin/bash

# WARNING: This script will remove ALL Docker containers and images!
echo "This script will remove ALL Docker containers and images. Proceed? [y/N]"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Stopping all running containers..."
    sudo docker stop $(sudo docker ps -q)
    
    echo "Removing all stopped containers..."
    sudo docker rm -f $(sudo docker ps -a -q)
    
    # Prune unused images (removes dangling and unused images)
    echo "Pruning unused Docker images..."
    sudo docker image prune -a

    # Optional: Remove ALL images (commented out as it's more drastic)
    # echo "Removing all Docker images..."
    # docker rmi -f $$(docker images -q)

    echo "Done!"
else
    echo "Aborting."
fi