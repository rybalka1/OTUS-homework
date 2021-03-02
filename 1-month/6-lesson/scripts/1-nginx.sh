#!/usr/bin/env bash

set -eux

echo Install build dependencies
sudo yum install -y \
    redhat-lsb-core \
    wget \
    rpmdevtools \
    rpm-build \
    createrepo \
    yum-utils
 
 echo Ad useradd
 sudo useradd builder
 sudo usermod -a -G root builder

echo Fetch sources
sudo -u vagrant wget -q https://nginx.org/packages/centos/7/SRPMS/nginx-1.18.0-1.el7.ngx.src.rpm

echo Install nginx SRPM
sudo -u vagrant rpm -i nginx-1.18.0-1.el7.ngx.src.rpm

echo Download and extract openssl-1.1.1a sources
sudo -u vagrant wget -q https://www.openssl.org/source/latest.tar.gz
sudo -u vagrant tar -xf latest.tar.gz

echo Install dependencies
yum-builddep --assumeyes rpmbuild/SPECS/nginx.spec

echo Update nginx.spec to build with openssl support
sudo -u vagrant sed -i 's#--with-debug#--with-openssl=/home/vagrant/openssl-1.1.1j#g' rpmbuild/SPECS/nginx.spec

echo Build nginx and create rpm package
sudo -u vagrant rpmbuild -bb rpmbuild/SPECS/nginx.spec

echo Install nginx
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm

echo Enable and run nginx
systemctl enable nginx
systemctl start nginx
systemctl status nginx
