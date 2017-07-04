sudo apt-get update
sudo apt-get install make
sudo apt-get install build-essential tcl
cd /tmp
wget http://download.redis.io/releases/redis-3.2.9.tar.gz
tar xzf redis-3.2.9.tar.gz
cd redis-3.2.9
sudo make
sudo make test
sudo make install
# configure redis
sudo mkdir /etc/redis
sudo cp /tmp/redis-3.2.9/redis.conf /etc/redis

x='supervised no'
y='supervised systemd'
sed -i -e "s/$x/$y/g" /etc/redis/redis.conf

sed -i -e 's/supervised no/supervised systemd/g' /etc/redis/redis.conf

# install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod
# start mongodb at boot
sudo systemctl enable mongod

# install php-mongo
sudo pecl install mongodb

