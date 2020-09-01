include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

helm: context helm-repo
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		docker-registry stable/docker-registry
.PHONY: helm

install: namespace cert helm ingressroute
.PHONY: install
