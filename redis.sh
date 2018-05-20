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

# Install php-redis
sudo apt-get install php-pear php-dev
sudo pecl install redis
sudo touch /etc/php/7.2/mods-available/redis.ini
sudo bash -c 'cat > /etc/php/7.2/mods-available/redis.ini << EOL
extension=redis.so
EOL'
sudo ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/fpm/conf.d/20-redis.ini
sudo ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/cli/conf.d/20-redis.ini
sudo phpenmod redis
sudo service php7.2-fpm restart

