# Install Composer (PHP dependencies manager)
## First install php-cli, unzip, git, curl, php-mbstring
sudo apt-get install curl git unzip
## Downloading and installing Composer
cd ~
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer