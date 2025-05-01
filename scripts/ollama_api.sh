#!/bin/bash

curl http://192.168.1.41:11434/api/generate -d '{
  "model": "deepseek-r1:1.5b",
  "prompt": "Why is the sky blue?",
  "stream": false
}'