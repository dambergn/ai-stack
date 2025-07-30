#!/bin/bash

# Create certs directory if it doesn't exist
mkdir -p /etc/ssl/certs

# Check if certificates already exist
if [ ! -f "/etc/ssl/certs/localhost.key" ] && [ ! -f "/etc/ssl/certs/localhost.crt" ]; then
    echo "Generating new certificates..."
    # Generate Self-Signed Certificates
    openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt -days 365 -nodes -subj "/C=US/ST=State/L=Locality/O=Organization/CN=localhost"
else
    echo "Certificates already exist. Skipping generation."
fi

