include ../global.mk
include vars.env
export $(shell sed 's/=.*//' vars.env)

default: install

prometheus: minikube-context
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		--values values.yaml \
		prometheus-operator stable/prometheus-operator
.PHONY: prometheus

pushgateway: minikube-context
	@helm upgrade \
		--install \
		--wait \
		--namespace ${NAMESPACE} \
		--values pushgateway.values.yaml \
		pushgateway stable/prometheus-pushgateway
.PHONY: pushgateway

install: namespace cert prometheus pushgateway ingressroute
