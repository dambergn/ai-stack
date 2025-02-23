#!/bin/bash
# Check Dependencies
function check_nvidia_driver_version {
    local target_version="$1"

    # Check if nvidia-smi is available
    if ! command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA drivers are not installed."
        echo "Note: installing the drivers will reboot the system automatically."
        echo "Run this script again after system reboot to continue."
        read -p $'\nWould you like to install them now? (yes/no): ' confirm
        if [[ ! "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Installation aborted."
        exit 1
        fi
        # Install Nvidia Driver
        sudo apt update
        sudo apt install -y ubuntu-drivers-common
        sudo apt install -y nvidia-driver-550
        sudo reboot
    fi

    # Get current driver version
    current_version=$(nvidia-smi | grep "Driver Version" | awk -F': ' '{print $2}')

    # Check if version extraction was successful
    if [[ -z "$current_version" ]]; then
        echo "Failed to retrieve NVIDIA driver version."
        return 1
    fi

    # Compare versions
    if [[ "$current_version" == "$target_version" ]]; then
        echo "NVIDIA driver version $current_version is installed."
        return 0
    else
        echo "NVIDIA driver version $current_version does not match target version $target_version."
        # exit
        return 1
    fi
}
check_nvidia_driver_version "550.120"
sleep 2

function check_docker_version {
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed."
        # Install docker & docker compose
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo apt-key fingerprint 0EBFCD88
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt update
        sudo apt install -y docker-ce
        sudo usermod -aG docker $USER

        # Create dockernet network
        sudo docker network create dockernet 


        # Install nvidia docker toolkit
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

        sudo apt-get update
        sudo apt-get install -y nvidia-container-toolkit
        sudo nvidia-ctk runtime configure --runtime=docker
        sudo systemctl restart docker
        sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

        echo "log out and back in to use docker without sudo"

        return 1
    fi
}
check_docker_version

CURRENT_DIR=$(pwd)

# Install functions
install_ollama() {
    echo "Installing Ollama..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/ollama"
    sudo docker compose up -d
}

install_open-webui() {
    echo "Installing Open WebUI..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/open-webui"
    sudo docker compose up -d
}

install_searxng() {
    echo "Installing SearXNG..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/searxng"
    sudo docker compose up -d
}

install_whispher() {
    echo "Installing Whispher..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/whishper"

    sudo echo "DB_USER=
    DB_PASS=
    WHISHPER_HOST=https://whisper.local.example.com
    WHISPER_MODELS=tiny,small
    PUID=
    PGID=" > .env

    sudo docker compose up -d
}

install_kokoro() {
    echo "Installing Kokoro..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/fastkoko"
    sudo docker compose down
    sudo docker compose up --build -d
}

install_comfyui() {
    echo "Installing ComfyUI..."
    # Add your specific install commands here
    cd "${CURRENT_DIR}/comfyui"
    ./pull-repo.sh
    sed -i "s|git reset --hard 276f8fce9f5a80b500947fb5745a4dde9e84622d && /|# git reset --hard 276f8fce9f5a80b500947fb5745a4dde9e84622d && /|g" stable-diffusion-webui-docker/services/comfy/Dockerfile
    sudo docker compose up -d
}

# Define software list and their install commands
software_list=(
    "Portainer - Optional: Docker WebUI"
    "Ollama - Required: LLM backend manager"
    "Open webUI - Front end chat interface"
    "SearXNG - Open Source Search Proxy"
    "Whispher - Speech-to-Text"
    "kokoro - Text-to-Speech"
    "ComfyUI - Image Generation"
)
install_commands=(
    "sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5"
    "install_ollama"
    "install_open-webui"
    "install_searxng"
    "install_whispher"
    "install_kokoro"
    "install_comfyui"
)
selected=()
for ((i=0; i<${#software_list[@]}; i++)); do
    selected[i]="false"
done
current_index=0

while true; do
    clear
    
    echo "Software Installer"
    echo "           
    _                               _ 
    _ __ ___ | |__  _______ _   _ ___    __ _(_)
    | '_ \` _ \\| '_ \|_  / __| | | / __|  / _\` | |
    | | | | | | | | |/ /\__ \ |_| \__ \ | (_| | |
    |_| |_| |_|_| |_/___|___/\__, |___/  \__,_|_|
                            |___/               "
    echo "Navigate with Up/Down arrow keys, press x to select/deselect, and 'q' to finish."
    
    for ((i=0; i<${#software_list[@]}; i++)); do
        if [ $i -eq $current_index ]; then
            printf "\033[32m>> \033[0m"  # Highlight current line
        else
            printf "    "
        fi
        
        if [ "${selected[i]}" = "true" ]; then
            echo "[X] ${software_list[i]}"
        else
            echo "[ ] ${software_list[i]}"
        fi
    done
    
    # Read input without echoing it
read -s -n1 key

case $key in
    # Up arrow
    A)
        if [ $current_index -gt 0 ]; then
            ((current_index--))
        fi
        ;;
    
    # Down arrow
    B)
        if [ $current_index -lt $((${#software_list[@]} - 1)) ]; then
            ((current_index++))
        fi
        ;;
    
    # 'x' to toggle selection
    x)
        if [ "${selected[$current_index]}" = "true" ]; then
            selected[$current_index]="false"
        else
            selected[$current_index]="true"
        fi
        ;;
    
    # 'q' to quit
    q)
        break
        ;;
esac
done

# Confirmation prompt
clear
echo -e "\nSelected software:"
for i in "${!software_list[@]}"; do
    if [ "${selected[$i]}" == "true" ]; then
        echo -e "\033[32m✓ \033[0m${software_list[$i]}"
    fi
done

read -p $'\nAre you sure you want to install these packages? (yes/no): ' confirm
if [[ ! "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Installation aborted."
    exit 1
fi

# Proceed with installation
echo -e "\nStarting installation..."

for i in "${!software_list[@]}"; do
    if [ "${selected[$i]}" == "true" ]; then
        command="${install_commands[$i]}"
        if type -t "$command" > /dev/null; then
            # It's a function, execute it
            $command
        else
            # Assume it's an install command, execute in shell
            eval "$command"
        fi
    fi
done
sudo docker restart portainer

echo -e "\nInstallation complete!"
echo "Portainer: https://localhost:9443"
echo "OpenWebUI: http://localhost:8080"
echo "SearXNG: http://localhost:8081"
echo "Whispher: http://localhost:8100"
echo "kokoro: http://localhost:8880/web"
echo "ComfyUI: http://localhost:7860"