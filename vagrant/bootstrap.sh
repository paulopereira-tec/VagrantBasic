#!/usr/bin/env bash

# Set timezone
ln -sf  /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

apt-get update
apt-get install -y curl git unzip

# ----------------------------------------------------------------------------------------------------------------------
# Setup and install MySQL
# ----------------------------------------------------------------------------------------------------------------------

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Installing packages
apt-get install -y mysql-server mysql-client

# Allow External Connections on your MySQL Service
sudo sed -i -e 's/bind-addres/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e 's/skip-external-locking/#skip-external-locking/g' /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root'; FLUSH privileges;"
sudo service mysql restart
# create client database
mysql -u root -proot -e "CREATE DATABASE bancoDeDados;"
#mysql -u root -proot bancoDeDados < /vagrant/vagrant/mysql/backup/bancoDeDados.sql

# ----------------------------------------------------------------------------------------------------------------------
# Setup and install PHP 7.4
# Caso aconteça de alguma biblioteca não for instalada automaticamente, faça a instalação manual dela
# ----------------------------------------------------------------------------------------------------------------------
apt install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install -y php7.4
apt-get install -y php7.4-fpm
apt-get install -y php-pear 
apt-get install -y php7.4-dev
apt-get install -y php7.4-mysql 
apt-get install -y php7.4-mbstring 
apt-get install -y php7.4-mcrypt 
apt-get install -y php7.4-xml 
apt-get install -y php7.4-gd 
apt-get install -y php7.4-zip 
apt-get install -y php7.4-curl 
apt-get install -y php7.4-intl
apt-get install libcurl3-openssl-dev

mkdir -p /vagrant/www/tmp/profile

cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# ----------------------------------------------------------------------------------------------------------------------'
# Setup and install Nginx
# Antes de instalar o Nginx, ele para o apache2 que vem instalado por padrão
# ----------------------------------------------------------------------------------------------------------------------
systemctl disable apache2
systemctl stop apache2
apt-get install -y nginx
mv /home/vagrant/nginx.conf /etc/nginx/nginx.conf
#mv /home/vagrant/app.conf /etc/nginx/sites-enabled/app.conf
rm /etc/nginx/sites-enabled/default
ln -s /vagrant/vagrant/nginx/sites-enabled/default.cnf /etc/nginx/sites-enabled/
systemctl restart nginx
systemctl enable nginx

# ----------------------------------------------------------------------------------------------------------------------
# Setup and install Redis
# ----------------------------------------------------------------------------------------------------------------------
apt-get -y install redis-server