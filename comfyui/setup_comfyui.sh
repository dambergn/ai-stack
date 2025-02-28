#!/bin/bash

echo "Fixing Dockerfile"
rm -rf stable-diffusion-webui-docker/services/comfy/Dockerfile
cp Dockerfile.tmp stable-diffusion-webui-docker/services/comfy/Dockerfile
