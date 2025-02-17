#!/bin/bash
# Check Dependencies
function check_nvidia_driver_version {
    local target_version="$1"

    # Check if nvidia-smi is available
    if ! command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA drivers are not installed."
        echo "Note: installing the drivers will reboot the system automatically. \n Run this script again after system reboot to continue."
        read -p $'\nWould you like to install them now? (yes/no): ' confirm
        if [[ ! "$confirm" =~ ^[yY][eE][sS]$ ]]; then
            echo "Installation aborted."
        exit 1
        fi
        # Install Nvidia Driver
        sudo apt update
        sudo apt install -y ubuntu-drivers-common
        sudo apt install nvidia-driver-550
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
check_nvidia_driver_version "550.12"
sleep 2

function check_docker_version {
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed."
        return 1
    fi

    # Attempt to retrieve Docker version
    if ! (docker --version > /dev/null); then
        echo "Failed to retrieve Docker version. Docker may not be running."
        return 1
    fi

    current_version=$(docker --version | awk '{print $3}')

    # Validate that a version was retrieved successfully
    if [[ -z "${current_version}" ]]; then
        echo "Failed to retrieve Docker version."
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        # No target version specified; only check installation and running state
        echo "Docker is installed with version: ${current_version}"
        return 0
    else
        # Compare current version with the provided target version
        target_version=$1
        if [[ "${current_version}" == "${target_version}" ]]; then
            echo "Docker version ${current_version} is installed."
            return 0
        else
            echo "Docker version mismatch. Current: ${current_version}, Target: ${target_version}"
            return 1
        fi
    fi
}


# Install functions
install_ollama() {
    echo "Installing Ollama..."
    # Add your specific install commands here
    cd ~/ai-stack/ollama
    sudo docker compose up
}

install_open-webui() {
    echo "Installing Open WebUI..."
    # Add your specific install commands here
    cd ~/ai-stack/open-webui
    sudo docker compose up
}

install_searxng() {
    echo "Installing SearXNG..."
    # Add your specific install commands here
    cd ~/ai-stack/searxng
    sudo docker compose up
}

install_whispher() {
    echo "Installing Whispher..."
    # Add your specific install commands here
    cd ~/ai-stack/whishper

    echo "DB_USER=
    DB_PASS=
    WHISHPER_HOST=https://whisper.local.example.com
    WHISPER_MODELS=tiny,small
    PUID=
    PGID=" > .env

    sudo docker compose up
}

install_kokoro() {
    echo "Installing Kokoro..."
    # Add your specific install commands here
    cd ~/ai-stack/fastkoko
    sudo docker compose up
}

install_comfyui() {
    echo "Installing ComfyUI..."
    # Add your specific install commands here
    cd ~/ai-stack/comfyui
    ./pull-repo.sh
    sed -i 's/git reset --hard 276f8fce9f5a80b500947fb5745a4dde9e84622d && \/# git reset --hard 276f8fce9f5a80b500947fb5745a4dde9e84622d && \/' stable-diffusion-webui-docker/services/comfy/Dockerfile
    sudo docker compose up
}

# Define software list and their install commands
software_list=(
    "Portainer"
    "Ollama"
    "Open webUI"
    "SearXNG"
    "Whispher - Note: not working"
    "kokoro"
    "ComfyUI"
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
    echo "           _                               _ 
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
if [[ ! "$confirm" =~ ^[yY][eE][sS]$ ]]; then
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

echo -e "\nInstallation complete!"