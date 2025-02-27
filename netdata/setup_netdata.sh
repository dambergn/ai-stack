#!/bin/bash

echo "netdata.example.org {
  reverse_proxy host.docker.internal:19999
  tls admin@example.org
}" > /opt/Caddyfile