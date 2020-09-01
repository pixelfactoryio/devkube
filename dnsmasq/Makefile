include ../global.mk

default: install

export define configure_dns_resolver
mkdir -p /etc/resolver
cat <<EOF > /etc/resolver/${BASE_DOMAIN}
nameserver 127.0.0.1
domain ${BASE_DOMAIN}
search_order 1
EOF
endef

export define configure_dnsmasq
test "${VM_IP}" && echo "Using ${VM_IP}" || exit 1
mkdir -p /usr/local/etc/dnsmasq.conf.d/
cat <<EOF > /usr/local/etc/dnsmasq.conf
listen-address=0.0.0.0
conf-dir=/usr/local/etc/dnsmasq.conf.d/
EOF
cat <<EOF > /usr/local/etc/dnsmasq.conf.d/${BASE_DOMAIN}.conf
address=/${BASE_DOMAIN}/${VM_IP}
EOF
endef

install: acquire-sudo
	$(call check_defined, VM_IP, Missing variable: VM_IP)
	$(call check_defined, BASE_DOMAIN, Missing variable: BASE_DOMAIN)
	@sudo bash -c "eval \"$$configure_dns_resolver\""
	@sudo bash -c "eval \"$$configure_dnsmasq\""
	@sudo brew services restart dnsmasq
	@ping -c 1 kube.${BASE_DOMAIN}
.PHONY: install
