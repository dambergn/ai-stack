#!/bin/bash

# curl http://192.168.1.41:11434/api/generate -d '{
#   "model": "deepseek-r1:1.5b",
#   "prompt": "Why is the sky blue?",
#   "stream": false
# }'

curl http://172.27.94.184:11434/api/generate -d '{
  "model": "qwen3:0.6b",
  "prompt": "Why is the sky blue?",
  "stream": false
}'