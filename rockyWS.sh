#!/bin/bash

dnf install nano git tar -yy
dnf update -y && dnf upgrade -y
dnf install epel-release yum-utils wget -yy
dnf install ntfs-3g htop glances nginx nodejs npm -yy

#install Terraform VSCode Azure-CLI AWS-CLI
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc

cat > /etc/yum.repos.d/vscode.repo << EOF
[vscode]
name=packages.microsoft.com
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

cat > /etc/yum.repos.d/azure-cli.repo << EOF
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

dnf install azure-cli code terraform -yy

mkdir /home/andy/awscli
cd /home/andy/awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -yy

#install ShellCheck
wget https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz
sudo tar -C /usr/local/bin/ -xf shellcheck-v0.8.0.linux.x86_64.tar.xz --no-anchored 'shellcheck' --strip=1

#install latest git
dnf remove git -yy
dnf remove git-*
dnf install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel expat-devel gcc autoconf -yy
wget https://www.kernel.org/pub/software/scm/git/git-2.36.0.tar.gz
tar -xvzf git-2.36.0.tar.gz
cd git-2.36.0
export PATH=$PATH:/usr/local/bin
make prefix=/usr/local all
make prefix=/usr/local install