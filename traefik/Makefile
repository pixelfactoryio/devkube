
include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

helm: context helm-repo
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		traefik traefik/traefik \
		--set "service.type=NodePort" \
		--set "ports.web.nodePort=32080" \
		--set "ports.websecure.nodePort=32443"
.PHONY: helm

install: namespace cert helm ingressroute
.PHONY: install
