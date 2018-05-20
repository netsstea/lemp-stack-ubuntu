# Install Mongodb Server
sudo apt-get install build-essential tcl
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod &
sudo systemctl enable mongod

# Install php-mongodb
sudo pecl install mongodb
sudo touch /etc/php/7.2/mods-available/mongo.ini
sudo bash -c 'cat > /etc/php/7.2/mods-available/mongo.ini << EOL
extension=mongodb.so
EOL'
sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/fpm/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/cli/conf.d/20-mongo.ini
sudo phpenmod mongo

sudo service php7.2-fpm restart



