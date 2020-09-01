include ../global.mk

default: install

## Root CA
certs/root-ca.crt certs/root-ca.key:
	@step certificate create \
		identity.dev.cluster.local certs/root-ca.crt certs/root-ca.key \
		--profile root-ca --not-after=87600h --no-password --insecure

## Linkerd Certificates
certs/identity.linkerd.crt certs/identity.linkerd.key: certs/root-ca.crt certs/root-ca.key
	@step certificate create \
		identity.linkerd.cluster.local certs/identity.linkerd.crt certs/identity.linkerd.key \
		--ca root-ca.crt --ca-key root-ca.key --profile intermediate-ca --not-after 8760h \
		--no-password --insecure

## Trust
keychain: acquire-sudo certs/root-ca.crt certs/root-ca.key
	@step certificate install certs/root-ca.crt
.PHONY: keychain

install: keychain
.PHONY: install
