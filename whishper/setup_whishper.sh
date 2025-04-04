#!/bin/bash

IP_ADDRESS=$(ip route get 8.8.8.8 | awk '{print $7}')

sudo echo "DB_USER=
    DB_PASS=
    WHISHPER_HOST=$IP_ADDRESS:8100
    WHISPER_MODELS=tiny,small
    PUID=
    PGID=" > .env