#!/usr/bin/env bash

# Install stuff
brew cask install minikube
brew install mkcert
brew install dnsmasq

# Configure stuff
sudo mkdir -p /etc/resolver

sudo tee /etc/resolver/dev.pixelfactory.io > /dev/null <<EOF
nameserver 127.0.0.1
domain dev.pixelfactory.io
search_order 1
EOF

mkdir -p /usr/local/etc/dnsmasq.conf.d/

sudo tee /usr/local/etc/dnsmasq.conf > /dev/null <<EOF
conf-dir=/usr/local/etc/dnsmasq.conf.d/
EOF