include global.mk
default: help

dnsmasq: ## Start Dnsmasq
	@$(MAKE) --directory=dnsmasq install
.PHONY: dnsmasq

kind: ## Start Kind cluster
	@$(MAKE) --directory=kind install
.PHONY: kind

smallstep: ## Create Smallstep SSL certificates
	@$(MAKE) --directory=smallstep install
.PHONY: smallstep

cert-manager: smallstep ## Install Cert-Manager
	@$(MAKE) --directory=cert-manager install
.PHONY: cert-manager

traefik: ## Install Traefik
	@$(MAKE) --directory=traefik install
.PHONY: traefik

registry: ## Install Docker Registry
	@$(MAKE) --directory=registry install
.PHONY: registry

postgresql: ## Install Postgresql
	@$(MAKE) --directory=postgresql install
.PHONY: postgresql

prometheus: ## Install prometheus
	@$(MAKE) --directory=prometheus install
.PHONY: prometheus

clean: ## Delete Kind cluster
	@$(MAKE) --directory=kind clean
.PHONY: clean
