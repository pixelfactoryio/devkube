include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

helm: context helm-repo
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		cert-manager jetstack/cert-manager \
		--version ${CERTMANAGER_VERSION}
.PHONY: helm

crd: context
	@kubectl apply --validate=false -f cert-manager.${CERTMANAGER_VERSION}.crds.yaml
.PHONY: crd

root-ca-secret:
	@kubectl \
		-n ${NAMESPACE} \
		create secret tls root-ca-key-pair \
		--cert ${ROOT_CA_CERTFILE} \
		--key ${ROOT_CA_KEYFILE} \
		--dry-run=client -o yaml | kubectl apply -f -
.PHONY: root-ca-secret

cluster-ca-issuer: root-ca-secret
	@envsubst < ca-issuer.yaml | kubectl --namespace ${NAMESPACE} apply -f -
.PHONY: cluster-ca-issuer

install: namespace crd helm root-ca-secret cluster-ca-issuer
	$(call check_defined, NAMESPACE, Missing variable: NAMESPACE)
	$(call check_defined, CERTMANAGER_VERSION, Missing variable: CERTMANAGER_VERSION)
.PHONY: install
