# ai-stack-v2

New version of my AI stack separating out each component instead of having them all be apart of the same docker compose.
After running setup.sh you can CD into each folder component and run docker compose up -d, or run start.sh to run them all.

## Docker Commands
```bash
docker network create dockernet
docker ps
docker images
```

## Ollama - LLM backend engine
- https://ollama.com/  

## Open WebUI - Web UI chat interface
- https://github.com/open-webui/open-webui

## SearXNG - For RAG web searches
- https://github.com/searxng/searxng

## Whishper - Speech to Text
- https://github.com/pluja/whishper

## FastKoko - Text to Speech
- https://github.com/remsky/Kokoro-FastAPI/blob/master/README.md

## ComfyUI - Imgage generation
- https://github.com/comfyanonymous/ComfyUI