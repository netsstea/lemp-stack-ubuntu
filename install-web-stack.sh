# Install Nginx
sudo bash -c 'cat > /etc/apt/sources.list.d/nginx.list << EOL
deb http://nginx.org/packages/ubuntu/ xenial nginx
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
EOL'

wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get update
sudo apt-get install nginx

# Install MariaDB
sudo apt-get install mariadb-server # Or MySQL: sudo apt-get install mysql-server
sudo service mysql stop # Stop the MySQL if is running.
sudo mysql_install_db
sudo service mysql start
sudo mysql_secure_installation

# Install PHP 7.0
sudo apt-get update
sudo apt-get install php

# Install needed modules for PHP
sudo apt-get install php7.0-fpm php7.0-mysql php7.0-curl php7.0-gd php7.0-mcrypt php7.0-sqlite3 php7.0-bz2 php7.0-mbstring php7.0-soap php7.0-xml php7.0-zip php7.0-mysql
php -v

# Restart Nginx to make effect
sudo service nginx restart ; sudo systemctl status nginx.service &

# Install Composer (PHP dependencies manager)
## First install php-cli, unzip, git, curl, php-mbstring
sudo apt-get install curl git unzip
## Downloading and installing Composer
cd ~
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Install php-redis
sudo apt-get install php-pear php-dev
sudo pecl install redis
sudo touch /etc/php/7.0/mods-available/redis.ini
sudo bash -c 'cat > /etc/php/7.0/mods-available/redis.ini << EOL
extension=redis.so
EOL'
sudo phpenmod redis

# Install php-mongodb
sudo pecl install mongodb
sudo touch /etc/php/7.0/mods-available/mongo.ini
sudo bash -c 'cat > /etc/php/7.0/mods-available/mongo.ini << EOL
extension=mongodb.so
EOL'
sudo phpenmod mongo

sudo systemctl restart php7.0-fpm

# Install Mongodb Server
sudo apt-get install build-essential tcl
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod &
sudo systemctl enable mongod

# Install Redis Server
cd /tmp
wget http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make && sudo make install
cd
sudo mkdir /etc/redis
sudo cp /tmp/redis-stable/redis.conf /etc/redis
sudo sed -i -e 's/supervised no/supervised systemd/g' /etc/redis/redis.conf
sudo sed -i -e 's/dir .\//dir \/var\/lib\/redis/g' /etc/redis/redis.conf

sudo touch /etc/systemd/system/redis.service
sudo bash -c 'cat > /etc/systemd/system/redis.service << EOL 
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
EOL'

sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis
sudo systemctl start redis
sudo systemctl status redis &
sudo systemctl enable redis


# Install nodejs via nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Install latest LTS version of node
# gnome-terminal -e nvm install --lts && nvm use --lts && nvm alias default 6.11.0
