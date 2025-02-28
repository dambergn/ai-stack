#!/bin/bash

rm -rf ./stable-diffusion-webui-docker/services/comfy/Dockerfile

echo "FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git && apt-get clean

ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \\
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \\
  cd $\{ROOT\} && \\
  git checkout master && \\
  pip install -r requirements.txt

WORKDIR ${ROOT}
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH=\"\${PYTHONPATH}:\${PWD}\" CLI_ARGS=\"\"
EXPOSE 7860
ENTRYPOINT [\"/docker/entrypoint.sh\"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}" > ./stable-diffusion-webui-docker/services/comfy/Dockerfile