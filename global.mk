SHELL=bash
MKFILE_PATH:=$(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR:=$(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
ROOT_BUILD_DIR:=$(shell dirname $(MKFILE_PATH))
ROOT_CA_CERTFILE=${ROOT_BUILD_DIR}/smallstep/certs/root-ca.crt
ROOT_CA_KEYFILE=${ROOT_BUILD_DIR}/smallstep/certs/root-ca.key

include ${ROOT_BUILD_DIR}/global.env
export $(shell sed 's/=.*//' ${ROOT_BUILD_DIR}/global.env)

global_vars=$(shell grep -rE "^[A-Z0-9_]*=.*$\" global.env | grep -v HELM | sed 's/global.env:/global#/')
apps_vars=$(shell grep -rE "^[A-Z0-9_]*=.*$\" */vars.env | grep -v HELM | sed 's/\/vars.env:/#/')

help: ## Display help
	@echo "Usage:"
	@echo "  make <target> <variables>"
	@echo ""
	@echo "Example:"
	@echo "  make kind KIND_CLUSTER_NAME=devkube"
	@echo ""
	@echo Defaults:
	@echo ${global_vars} ${apps_vars} | tr ' ' '\n' | column -t -c 2 -s '#' | sed 's/^/  /'
	@echo ""
	@echo "Targets:"
	@sed -n 's/:.*[#]#/:#/p' $(firstword $(MAKEFILE_LIST)) | sort | column -t -c 2 -s ':#' | sed 's/^/  /'
.PHONY: help

check_defined = \
	$(strip $(foreach 1,$1, \
	$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
	$(if $(value $1),, \
	$(error Undefined $1$(if $2, ($2))))

acquire-sudo:
	@sudo echo -n
.PHONY: acquire-sudo

context:
	$(call check_defined, KIND_CLUSTER_NAME, Missing variable: KIND_CLUSTER_NAME)
	@kubectl config use-context kind-${KIND_CLUSTER_NAME}
.PHONY: minikube-context

namespace: context
	$(call check_defined, NAMESPACE, Missing variable: NAMESPACE)
	@kubectl \
		create namespace ${NAMESPACE} \
		--dry-run=client -o yaml | kubectl apply -f -
.PHONY: namespace

helm-repo:
	$(call check_defined, HELM_REPO_NAME, Missing variable: HELM_REPO_NAME)
	$(call check_defined, HELM_REPO_URL, Missing variable: HELM_REPO_URL)
	@helm repo add ${HELM_REPO_NAME} ${HELM_REPO_URL}
	@helm repo update
.PHONY: helm-repo

cert: context
	$(call check_defined, NAMESPACE, Missing variable: NAMESPACE)
	$(call check_defined, BASE_DOMAIN, Missing variable: BASE_DOMAIN)
	@envsubst < cert.yaml | kubectl --namespace ${NAMESPACE} apply -f -
.PHONY: cert

ingressroute: context
	$(call check_defined, NAMESPACE, Missing variable: NAMESPACE)
	@envsubst < ingress.yaml | kubectl --namespace ${NAMESPACE} apply -f -
.PHONY: traefik-ingressroute
