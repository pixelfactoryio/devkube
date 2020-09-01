include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

helm: context helm-repo
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		--set image.tag=${POSTGRES_VERSION} \
		--set global.postgresql.postgresqlPassword=changeme \
		--set persistence.enabled=false \
		postgresql bitnami/postgresql
.PHONY: helm

install: namespace helm
.PHONY: install
