read -p "Write the host name, eg. google:" HOST;
read -p "Write the 1st level domain name without starting dot (.), eg. com.au:" DOMAIN;
read -p "Write the link of git respository:" GITREPO;
read -p "Where is folder index.html or index.php file located in:" INDEX;

mkdir -p /var/www/vhosts/$HOST.$DOMAIN/
cd /var/www/vhosts/$HOST.$DOMAIN/ && git clone $GITREPO && cd

groupadd $HOST
useradd -g $HOST -d /var/www/vhosts/$HOST.$DOMAIN $HOST
passwd $HOST

chown -R $HOST:$HOST /var/www/vhosts/$HOST.$DOMAIN
chmod -R 0775 /var/www/vhosts/$HOST.$DOMAIN

touch /etc/apache2/sites-available/$HOST.$DOMAIN

echo "<VirtualHost *:80>
    ServerAdmin quangdv190@gmail.com
    ServerName $HOST.$DOMAIN
    ServerAlias $HOST.$DOMAIN

    DocumentRoot /var/www/vhosts/$HOST.$DOMAIN/
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>
    <Directory /var/www/vhosts/$HOST.$DOMAIN/
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from All
        Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/$HOST.$DOMAIN

ln -s /etc/apache2/sites-available/$HOST.$DOMAIN /etc/apache2/sites-enabled/$HOST.$DOMAIN
service apache2 restart ; systemctl status apache2

rm ./add-apache-vhost.sh