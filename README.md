# Minikube

## TL;DR

```bash
./install.sh
```

```bash
make all
```

## Install

1. Minikube

```bash
brew cask install minikube
```

1. MKCert

```bash
brew install mkcert
```

1. DNSMasq

```bash
brew install dnsmasq
```

## Configuratin

1. Dnsmasq

```bash
sudo mkdir -p /etc/resolver
```

```bash
sudo tee /etc/resolver/dev.pixelfactory.io > /dev/null <<EOF
nameserver 127.0.0.1
domain dev.pixelfactory.io
search_order 1
EOF
```

```bash
mkdir -p /usr/local/etc/dnsmasq.conf.d/
```

```bash
sudo tee /usr/local/etc/dnsmasq.conf > /dev/null <<EOF
conf-dir=/usr/local/etc/dnsmasq.conf.d/
EOF
```

## Usage 

```bash
$ make
Usage:
  make <target>

Targets:
  dnsmasq         Update DNSMasq configuration
  helm            Install Helm
  help            Display help.
  minikube        Start Minikube
  mkcert          Install mkcert
  traefik         Install Traefik
```