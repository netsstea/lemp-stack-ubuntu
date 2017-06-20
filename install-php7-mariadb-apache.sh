sudo add-apt-repository ppa:nginx/development
sudo apt-get update
sudo apt-get install nginx

sudo apt-get install mariadb-server # Or MySQL: sudo apt-get install mysql-server
sudo service mysql stop # Stop the MySQL if is running.
sudo mysql_install_db
sudo service mysql start
sudo mysql_secure_installation


sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install php7.1

sudo apt-get install php7.1-fpm php7.1-mysql php7.1-curl php7.1-gd php7.1-mcrypt php7.1-sqlite3 php7.1-bz2 php7.1-mbstrin php7.1-soap php7.1-xml php7.1-zip php7.1-mysql
php -v

sudo service nginx restart ; sudo systemctl status nginx.service