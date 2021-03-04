#!/bin/sh

set -exuo pipefail

cat << EOF
###
# HTTPD multiple instances
###
EOF

echo Install necessary packages
sudo yum install -y httpd

echo "Provide /etc/sysconfig/httpd@* configs"
cat << EOF | sudo tee /etc/sysconfig/httpd@8080
LANG=C
OPTIONS=-d /etc/httpd-8080
EOF
cat << EOF | sudo tee /etc/sysconfig/httpd@8081
LANG=C
OPTIONS=-d /etc/httpd-8081
EOF

echo Create serverroot directories
sudo cp -a /etc/httpd /etc/httpd-8080
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8080"#g' /etc/httpd-8080/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8080#g' /etc/httpd-8080/conf/httpd.conf
sudo cp -a /etc/httpd /etc/httpd-8081
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8081"#g' /etc/httpd-8081/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8081#g' /etc/httpd-8081/conf/httpd.conf

echo Provide systemd service template and target
sudo cp httpd@.service /etc/systemd/system/httpd@.service
sudo cp httpd.target /etc/systemd/system/httpd.target
sudo chown root:root /etc/systemd/system/httpd@.service
sudo chown root:root /etc/systemd/system/httpd.target
echo Reread systemd unit-files
sudo systemctl daemon-reload

echo Enamble and start services
{
    sudo systemctl enable httpd@808{0,1}.service
    sudo systemctl enable httpd.target
    sudo systemctl start httpd.target
}

echo Check services are running
systemctl status httpd.target httpd@808{0,1}.service
