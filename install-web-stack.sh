# Install Nginx
sudo add-apt-repository ppa:nginx/development
sudo apt-get update
sudo apt-get install nginx

# Install MariaDB
sudo apt-get install mariadb-server # Or MySQL: sudo apt-get install mysql-server
sudo service mysql stop # Stop the MySQL if is running.
sudo mysql_install_db
sudo service mysql start
sudo mysql_secure_installation

# Install PHP 7.1
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install php7.1

# Install needed modules for PHP
sudo apt-get install php7.1-fpm php7.1-mysql php7.1-curl php7.1-gd php7.1-mcrypt php7.1-sqlite3 php7.1-bz2 php7.1-mbstrin php7.1-soap php7.1-xml php7.1-zip php7.1-mysql
php -v

# Restart Nginx to make effect
sudo service nginx restart ; sudo systemctl status nginx.service

# Install Composer (PHP dependencies manager)
## First install php-cli, unzip, git, curl, php-mbstring
sudo apt-get install curl git unzip
## Downloading and installing Composer
cd ~
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
## Test Composer working well
composer

# Install nodejs via nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Install latest LTS version of node
nvm install --lts

# Use LTS version as default
nvm use --lts
# current latest LTS is 6.11.0
nvm alias default 6.11.0
