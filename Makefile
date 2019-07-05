KUBE_VERSION="v1.14.3"
TRAEFIK_VERSION="1.7-alpine"
BASE_DOMAIN="dev.pixelfactory.io"
MINIKUBE_CONTEXT:=$(shell kubectl config use-context minikube)
MINIKUBE_VM_DRIVER="virtualbox"
MINIKUBE_CPU="2"
MINIKUBE_MEMORY="6144"
MINIKUBE_DISK="20g"
MINIKUBE_CIDR="192.168.100.1/24"
MKCERT_CERTFILE="/usr/local/etc/pixelfactory.io/ssl/${BASE_DOMAIN}.pem"
MKCERT_KEYFILE="/usr/local/etc/pixelfactory.io/ssl/${BASE_DOMAIN}-key.pem"

.PHONY: help minikube dnsmasq mkcert helm traefik all
default: help

help: ## Display help.
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

clean-dhcp:
	@rm /Users/${USER}/Library/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases

minikube: ## Start Minikube
	@minikube start \
		--vm-driver=${MINIKUBE_VM_DRIVER} \
		--bootstrapper=kubeadm \
		--memory=${MINIKUBE_MEMORY} \
		--cpus=${MINIKUBE_CPU} \
		--disk-size=${MINIKUBE_DISK} \
		--host-only-cidr=${MINIKUBE_CIDR} \
		--insecure-registry=registry.${BASE_DOMAIN} \
		--kubernetes-version=${KUBE_VERSION} \
		--extra-config=apiserver.authorization-mode=RBAC \
		--extra-config=apiserver.service-node-port-range=80-50000

dnsmasq: ## Update DNSMasq configuration
	$(eval MINIKUBE_IP=$(shell minikube ip))
	@echo "Update DNSMasq configuration"
	@echo "address=/${BASE_DOMAIN}/${MINIKUBE_IP}" > /usr/local/etc/dnsmasq.conf.d/${BASE_DOMAIN}.conf
	@sudo brew services restart dnsmasq
	@ping -c 1 kube.${BASE_DOMAIN}

mkcert: ## Install mkcert
	$(eval MINIKUBE_IP=$(shell minikube ip))
	@mkdir -p /usr/local/etc/pixelfactory.io/ssl
	@mkcert -install
	@mkcert -cert-file ${MKCERT_CERTFILE} -key-file ${MKCERT_KEYFILE} 127.0.0.1 *.${BASE_DOMAIN} ${MINIKUBE_IP}

helm: ## Install Helm
	@helm init --wait
	@helm repo update

traefik: ## Install Traefik
	@kubectl \
		-n kube-system \
		create secret tls ${BASE_DOMAIN} \
		--cert ${MKCERT_CERTFILE} \
		--key ${MKCERT_KEYFILE} \
		--dry-run=true -o yaml | kubectl apply -f -
	@helm upgrade \
  		--install \
  		--namespace kube-system \
  		traefik stable/traefik \
		--set "imageTag=${TRAEFIK_VERSION}" \
		--set "kubernetes.ingressClass=traefik-private" \
		--set "rbac.enabled=true" \
		--set "debug.enabled=true" \
		--set "ssl.enabled=true" \
		--set "serviceType=NodePort" \
		--set "service.nodePorts.http=80" \
		--set "service.nodePorts.https=443" \
		--set "accessLogs.enabled=true" \
		--set "accessLogs.format=json" \
		--set "dashboard.enabled=true" \
		--set "dashboard.domain=traefik.${BASE_DOMAIN}" \
		--set "dashboard.ingress.tls[0].secretName=${BASE_DOMAIN}" \
		--set "dashboard.ingress.annotations.'kubernetes\.io/ingress\.class'=traefik-private"
		
all: minikube dnsmasq mkcert helm traefik ## Install everything
