read -p "Write the host name, eg. google:" JENKINSNAME;
read -p "Write the 1st level domain name without starting dot (.), eg. com.au:" DOMAIN;
read -p "Where is folder index.html or index.php file located in:" INDEX;

touch /etc/apache2/sites-available/$JENKINSNAME.$DOMAIN

echo "<VirtualHost *:80>
    ServerAdmin quangdv190@gmail.com
    ServerName $JENKINSNAME.$DOMAIN
    ServerAlias $JENKINSNAME.$DOMAIN

    DocumentRoot /var/lib/jenkins/workspace/$JENKINSNAME/$INDEX
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>
    <Directory /var/lib/jenkins/workspace/$JENKINSNAME/$INDEX>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from All
        Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/$JENKINSNAME.$DOMAIN

ln -s /etc/apache2/sites-available/$JENKINSNAME.$DOMAIN /etc/apache2/sites-enabled/$JENKINSNAME.$DOMAIN
service apache2 restart ; systemctl status apache2

rm ./add-apache-vhost.sh