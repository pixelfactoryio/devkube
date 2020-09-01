include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

kind:
	$(call check_defined, KIND_CLUSTER_NAME, Missing variable: KIND_CLUSTER_NAME)
	$(call check_defined, KIND_KUBE_VERSION, Missing variable: KIND_KUBE_VERSION)
	@envsubst < kind.yaml | kind create cluster --name=${KIND_CLUSTER_NAME} --config -
	# Scale down coredns to 1 replicas to save resources
	@kubectl scale deployment --replicas 1 coredns --namespace kube-system
.PHONY: kind

clean:
	$(call check_defined, KIND_CLUSTER_NAME, Missing variable: KIND_CLUSTER_NAME)
	@kind delete cluster --name ${KIND_CLUSTER_NAME}
.PHONY: clean

install: kind
.PHONY: install
