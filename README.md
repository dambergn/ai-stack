# ai-stack-v2

New version of my AI stack separating out each component instead of having them all be apart of the same docker compose.
After running setup.sh you can CD into each folder component and run docker compose up -d, or run start.sh to run them all.  
This is based of Techno Tim but I have made significant changes to his implimentation.  https://www.youtube.com/watch?v=yoze1IxdBdM&t=3301s  

## Prerequisits
You will want to install your Nvidia drivers first you will want to reboot after installation.
```bash
./install_nvidia_drivers.sh
```
Then install the docker and nvida toolkit.  NOTE: you will have to log out and back in for your user to be able to run docker commands without using sudo.
```bash
./install_docker.sh
```

## Docker Commands
```bash
docker ps
docker images
## Docker compose commands
docker compose up
docker compose down
docker compose up -d <-- no console output.
## Create dockernet network
docker network create dockernet  # You will want to create this network before starting components.
```
### Note: I recommend starting each container with compose up and not -d for the first run to make sure everything works, if there is a problem you will be able to see it in the output.  Once you confirm its working properly you can use Ctrl + c to stop it, then run it again with the -d flag, then move on to the next component.


## Portainer(optional) - Web based docker GUI
```bash
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.5
```
URL: https://localhost:9440
It will ask you to create a uername and password on firtst launch.  

## Ollama - LLM backend engine
- https://ollama.com/  
```bash
cd ~/ai-stack/ollama
docker compose up
# Common ollama commands
ollama version                 # shows which version is istalled.
ollama pull <model>            # For downloading a model without starting it.
ollama run <model>             # Run a model, will download if not already on system.
ollama run <model> --verbose   #  Will run model and give analytics at the end of request.
ollama ps                      # Shows running LLM's
```

## Open WebUI - Web UI chat interface
- https://github.com/open-webui/open-webui
```bash
cd ~/ai-stack/open-webui
docker compose up
```
URL: http://localhost:3000

## SearXNG - For RAG web searches
- https://github.com/searxng/searxng
```bash
cd ~/ai-stack/searxng
docker compose up
```
URL: http://localhost:8081

## Whishper - Speech to Text
- https://github.com/pluja/whishper
```bash
cd ~/ai-stack/whishper
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