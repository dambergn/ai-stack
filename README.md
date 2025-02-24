# ai-stack-v2

New version of my AI stack separating out each component instead of having them all be apart of the same docker compose.
After running setup.sh you can CD into each folder component and run docker compose up -d, or run start.sh to run them all.  
This is based of Techno Tim but I have made significant changes to his implimentation.  https://www.youtube.com/watch?v=yoze1IxdBdM&t=3301s  


## Easy/Automated Install method
Ensure nvidia drivers are installed and working.
Run
```bash
./setup.sh
```
Seclect the options you want to install and follow instructions in script.

Featured by Canuck Creator demonstrating the installation and setup process.  
https://www.youtube.com/watch?v=ynQb5IH-xEI&t=153s  


# Manual installation instructions
### Prerequisits
You will want to install your Nvidia drivers, the system will reboot itself after the driver installation.
```bash
./install_nvidia_drivers.sh
```
Then install the docker and nvida toolkit.  NOTE: you will have to log out and back in for your user to be able to run docker commands without using sudo.

```bash
./install_docker.sh
```

## Docker Commands
```bash
docker ps                        # Displays running containers
docker images                    # Displays images on the system
## Docker compose commands
docker compose up                # Builds the docker environment in the compose file
docker compose down              # Shuts down and removes containers
docker compose up -d             # Builds and runs docker envronment with no console output.
## Create dockernet network
docker network create dockernet  # You will want to create this network before starting components.
```
### Note: I recommend starting each container with compose up and not -d for the first run to make sure everything works, if there is a problem you will be able to see it in the output.  Once you confirm its working properly you can use Ctrl + c to stop it, then run it again with the -d flag, then move on to the next component.


## Portainer(optional) - Web based docker GUI
```bash
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
```
URL: https://localhost:9443
It will ask you to create a uername and password on firtst launch.  

## Ollama - LLM backend engine
- https://ollama.com/  
NOTE: make sure you have created the dockernet network first before you start running docker compose, this only needs to be done once.  docker network create dockernet
```bash
cd ~/ai-stack/ollama
docker compose up
# Common ollama commands
docker exec ollama --version               # shows which version is istalled.
docker exec ollama pull <model>            # For downloading a model without starting it.
docker exec ollama run <model>             # Run a model, will download if not already on system.
docker exec ollama run <model> --verbose   #  Will run model and give analytics at the end of request.
docker exec ollama ps                      # Shows running LLM's
docker exec ollama list                    # Shows installed models.
```

## Open WebUI - Web UI chat interface
- https://github.com/open-webui/open-webui
```bash
cd ~/ai-stack/open-webui
docker compose up
```
URL: http://localhost:8080
Note: for Mic to work the web UI must be accessed via localhost or over https with SSL. --> https://github.com/open-webui/open-webui/discussions/3012  

## SearXNG - For RAG web searches
- https://github.com/searxng/searxng
```bash
cd ~/ai-stack/searxng
docker compose up
```
URL: http://localhost:8081

## Whishper - Speech to Text
- https://github.com/pluja/whishper
Note: Before running docker compose, inside the whispher folder create a .env file with the provided variables.  They do not need to be populated but the compose file does need the file to be there.

```bash
cd ~/ai-stack/whishper
nano .env

DB_USER=
DB_PASS=
WHISHPER_HOST=https://whisper.local.example.com
WHISPER_MODELS=tiny,small
PUID=
PGID=

# Ctrl x y

docker compose up
```
URL: http://localhost:8100

## FastKoko - Text to Speech
- https://github.com/remsky/Kokoro-FastAPI/blob/master/README.md
```bash
cd ~/ai-stack/fastkoko
docker compose up
```
URL: http://localhost:8880/web/
### Adding kokoro to open-webui
- https://docs.openwebui.com/tutorials/text-to-speech/Kokoro-FastAPI-integration

## ComfyUI - Image generation
- https://github.com/comfyanonymous/ComfyUI
```bash
cd ~/ai-stack/comfyui
./pull-repo.sh
nano stable-diffusion-webui-docker/services/comfy/Dockerfile
# comment out line and save file
#  git reset --hard 276f8fce9f5a80b500947fb5745a4dde9e84622d && \
docker compose up
```
URL: http://localhost:7860

## Logo
```

           _                               _ 
 _ __ ___ | |__  _______ _   _ ___    __ _(_)
| '_ ` _ \| '_ \|_  / __| | | / __|  / _` | |
| | | | | | | | |/ /\__ \ |_| \__ \ | (_| | |
|_| |_| |_|_| |_/___|___/\__, |___/  \__,_|_|
                         |___/               


```