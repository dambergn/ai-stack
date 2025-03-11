#!/bin/bash

mkdir certs

# Generate Self Assigned Cert
openssl req -x509 -newkey rsa:4096 -keyout certs/localhost.key -out certs/localhost.crt -days 365 -nodes -subj "/C=US/ST=State/L=Locality/O=Organization/CN=localhost"