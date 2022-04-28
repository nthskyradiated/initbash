#!/bin/bash

#run as root

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF

TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
UUID="3a76926b-a60b-4d0b-9ae6-c94f3e6925e3"
DEVICE="eth0"
ONBOOT="yes"
IPADDR=172.20.100.20
NETMASK=255.255.255.0
GATEWAY=172.20.100.1
DNS1=8.8.8.8
DNS2=9.9.9.9
EOF

systemctl restart network

yum update -y && yum upgrade -y
yum install epel-release yum-utils -yy
yum install htop glances nginx nodejs npm ntfs-3g -yy

yum remove git
yum remove git-*
yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel expat-devel gcc autoconf -yy
wget https://www.kernel.org/pub/software/scm/git/git-2.36.0.tar.gz
tar -xvzf git-2.36.0.tar.gz
cd git-2.36.0
make prefix=/usr/local all
make prefix=/usr/local install
cd /home/admin/Desktop/
git clone https://github.com/nthskyradiated/NthSkySpace.git
cp -R ./NthSkySpace /usr/share/nginx/html/


firewall-cmd --zone=public --add-port=4000/tcp
firewall-cmd --zone=public --add-port=4433/tcp
firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=https
firewall-cmd --zone=public --add-service=ssh
firewall-cmd --permanent --zone=public --add-port=4000/tcp
firewall-cmd --permanent --zone=public --add-port=4433/tcp
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-service=ssh
systemctl restart firewalld

rpm --import https://packages.microsoft.com/keys/microsoft.asc

cat > /etc/yum.repos.d/vscode.repo <<EOF
[vscode]
name=packages.microsoft.com
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

cat > /etc/yum.repos.d/azure-cli.repo <<EOF
[azure-cli]
name=azure-cli
baseurl=https://packages.microsoft.com/yumrepos/azure-cli/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

yum install code azure-cli -yy

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum install terraform -yy

curl -fsSL https://get.docker.com -o get-docker.sh &&
sh get-docker.sh

curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip &&
unzip awscliv2.zip
./aws/install -y

wget https://github.com/koalaman/shellcheck/releases/download/v.0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz
tar -C /usr/local/bin -xf shellcheck-v.0.8.0.linux.x86_64.tar.xz --no-anchored 'shellcheck' --strip=1

while
	npm install -g resume-cli --unsafe-perm=true
	[ $? -ne 0 ]
do true; done

mkdir ./resume
cd resume
cp /home/admin/Desktop/NthSkySpace/resume.json ./resume.json
while
	npm install resume-cli --unsafe-perm=true
	[ $? -ne 0 ]
do true; done

npm install jsonresume-theme-elegant
npm install jsonresume-theme-stackoverflow
npm install jsonresume-theme-caffeine
npm install jsonresume-theme-kendall
npm install jsonresume-theme-autumn
npm install jsonresume-theme-spartan
npm install jsonresume-theme-elegant -g
npm install jsonresume-theme-stackoverflow -g
npm install jsonresume-theme-caffeine -g
npm install jsonresume-theme-kendall -g
npm install jsonresume-theme-autumn -g
npm install jsonresume-theme-spartan -g

