#!/bin/bash

#source as root
dnf install nano git -yy
dnf update -y && dnf upgrade -y
dnf install epel-release yum-utils wget -yy
dnf install htop glances nginx nodejs npm -yy

sed '5 c\BOOTPROTO="static"' /etc/sysconfig/network-scripts/ifcfg-eth0
cat >> /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
IPADDR=172.20.100.20
NETMASK=255.255.255.0
GATEWAY=172.20.100.1
DNS1=8.8.8.8
DNS2=9.9.9.9
EOF

ifcfg eth0 down
ifcfg eth0 up
#systemctl restart NetworkManager

dnf remove git -yy
dnf remove git-*
dnf install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel expat-devel gcc autoconf -yy
wget https://www.kernel.org/pub/software/scm/git/git-2.36.0.tar.gz
tar -xvzf git-2.36.0.tar.gz
cd git-2.36.0
export PATH=$PATH:/usr/local/bin
make prefix=/usr/local all
make prefix=/usr/local install

wget https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz
sudo tar -C /usr/local/bin/ -xf shellcheck-v0.8.0.linux.x86_64.tar.xz --no-anchored 'shellcheck' --strip=1


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

while
	npm install -g resume-cli --unsafe-perm=true
	[ $? -ne 0 ]
do true; done

cd /home/admin
mkdir /home/admin/resume
git clone https://github.com/nthskyradiated/NthSkySpace.git
cp ./NthSkySpace/resume.json ./resume/resume.json
cp -R ./NthSkySpace /usr/share/nginx/html/
cd /home/admin/resume

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

cat > /etc/nginx/conf.d/andypandaan.info.conf <<EOF
server {
	root /home/admin/resume;
	index index.html index.htm index.js;
	server_name andypandaan.info www.andypandaan.info;
	access_log /var/log/nginx/andypandaan.info.access.log;
	error_log /var/log/nginx/andypandaan.info.error.log;

	location / {
		proxy_pass http://localhost:4000;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Host \$host;
		proxy_cache_bypass \$http_upgrade;
	}
}
EOF

cat > /etc/nginx/conf.d/nthsky.me.conf <<EOF
server {
	root /usr/share/nginx/html/NthSkySpace;
	index index.html index.htm;
	server_name nthsky.me www.nthsky.me;
	access_log /var/log/nginx/nthsky.me.access.log;
	error_log /var/log/nginx/nthsky.me.error.log;

	location / {
		try_files \$uri \$uri/ =404;
	}
}
EOF

systemctl restart nginx