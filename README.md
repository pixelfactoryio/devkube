# DevKube (kind)

## Install

1. GNU Make

```bash
brew install make
```

1. Smallstep (SSL certificates)

```bash
brew install step
```

1. DNSMasq

```bash
brew install dnsmasq
```

## Usage

```bash
$ make
Usage:
  make <target> <variables>

Example:
  make kind KIND_CLUSTER_NAME=devkube

Defaults:
  global        KIND_CLUSTER_NAME=devkube
  global        BASE_DOMAIN=dev.local
  cert-manager  NAMESPACE=cert-manager-system
  cert-manager  CERTMANAGER_VERSION=v0.16.1
  kind          KIND_KUBE_VERSION=kindest/node:v1.17.5@sha256:ab3f9e6ec5ad8840eeb1f76c89bb7948c77bbf76bcebe1a8b59790b8ae9a283a
  postgresql    NAMESPACE=postgres-system
  postgresql    POSTGRES_VERSION=10
  prometheus    NAMESPACE=monitoring
  registry      NAMESPACE=registry-system
  traefik       NAMESPACE=traefik-system

Targets:
  cert-manager   Install Cert-Manager
  clean          Delete Kind cluster
  dnsmasq        Start Dnsmasq
  kind           Start Kind cluster
  postgresql     Install Postgresql
  prometheus     Install prometheus
  registry       Install Docker Registry
  smallstep      Create Smallstep SSL certificates
  traefik        Install Traefik
```

### Start Kind

```bash
$ make kind

$ make dnsmasq smallstep
```

### Add Cert-Manager

```bash
$ make cert-manager
```

### Add Traefik

```bash
$ make traefik
```

Traefik dashboard should be reachable <https://traefik.dev.local>

### Add Docker registry

```bash
$ make registry
```

Ex:

```bash
$ docker build -t registry.dev.local/my-app:v1.0.0 -f Dockerfile .
$ docker push registry.dev.local/my-app:v1.0.0
```
