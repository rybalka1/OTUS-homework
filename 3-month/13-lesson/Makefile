
# Create venv and install requirements
venv:
	test -d ./.venv || python3 -m venv ./.venv
	./.venv/bin/pip install -r requirements.txt
	@echo To activate venv, run:
	@echo source .venv/bin/activate

###
# Task 1: nginx
###
nginx-create:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule create

nginx-converge:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule converge

nginx-verify:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule verify

nginx-destroy:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule destroy

nginx-test: nginx-create nginx-converge nginx-verify
	echo "Don't forget to cleanup, run"
	echo "make nginx-clean"

nginx-clean: nginx-destroy


###
# Task 2: dns
###
dns-create:
	cd ./selinux_dns_problems \
	&& vagrant up

dns-provision:
	cd ./selinux_dns_problems \
	&& vagrant provision

dns-ssh-ns01:
	cd ./selinux_dns_problems \
	&& vagrant ssh ns01

dns-ssh-client:
	cd ./selinux_dns_problems \
	&& vagrant ssh client

dns-destroy:
	cd ./selinux_dns_problems \
	&& vagrant destroy -f

dns-test: dns-create
	echo "Don't forget to cleanup, run"
	echo "make dns-clean"

dns-clean: dns-destroy


###
# Common
###
clean: nginx-clean dns-clean
