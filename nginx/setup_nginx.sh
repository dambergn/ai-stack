#!/bin/bash

# mkdir certs
# sudo chmod 0777 certs

# # Generate Self Assigned Cert
# openssl req -x509 -newkey rsa:4096 -keyout certs/localhost.key -out certs/localhost.crt -days 365 -nodes -subj "/C=US/ST=State/L=Locality/O=Organization/CN=localhost"


# Create certs directory if it doesn't exist
mkdir -p certs

# Check if certificates already exist
if [ ! -f "certs/localhost.key" ] && [ ! -f "certs/localhost.crt" ]; then
    echo "Generating new certificates..."
    # Generate Self-Signed Certificates
    openssl req -x509 -newkey rsa:4096 -keyout certs/localhost.key -out certs/localhost.crt -days 365 -nodes -subj "/C=US/ST=State/L=Locality/O=Organization/CN=localhost"
else
    echo "Certificates already exist. Skipping generation."
fi

# Set directory permissions (if necessary)
sudo chmod 0777 certs