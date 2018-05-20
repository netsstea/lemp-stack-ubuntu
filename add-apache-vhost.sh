read -p "Write the host name, eg. google:" HOST;
read -p "Write the 1st level domain name without starting dot (.), eg. com.au:" DOMAIN;

mkdir -p /var/www/$HOST.$DOMAIN/web
mkdir -p /var/www/$HOST.$DOMAIN/logs
mkdir -p /var/www/$HOST.$DOMAIN/ssl

touch /etc/apache2/sites-available/$HOST.$DOMAIN

echo "<VirtualHost *:80>
    ServerAdmin admin@$HOST.$DOMAIN
    ServerName $HOST.$DOMAIN www.$HOST.$DOMAIN
    ServerAlias $HOST.$DOMAIN

    ErrorLog /var/www/$HOST.$DOMAIN/logs/error.log
    LogLevel warn
    CustomLog /var/www/$HOST.$DOMAIN/logs/access.log combined
    
    DocumentRoot /var/www/$HOST.$DOMAIN/web
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>
    <Directory /var/www/$HOST.$DOMAIN/web/ >
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from All
        Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/$HOST.$DOMAIN

ln -s /etc/apache2/sites-available/$HOST.$DOMAIN /etc/apache2/sites-enabled/$HOST.$DOMAIN.conf

service apache2 restart