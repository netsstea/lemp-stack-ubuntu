# How to install Nginx on ubuntu 16.04

**Last update**: 7/4/2017, tested on Ubuntu 16.04

1. [Install Essential libraries](#install-essential-library)
2. [Install Nginx](#install-nginx)
    1. [Setting Nginx](#setting-nginx)


### #Install Essential Libraries
N/A
### #Install Nginx

```sh
sudo apt-get update
sudo apt-get install nginx
```

We can check with the systemd init system to make sure the service is running by typing:
```sh
systemctl status nginx
```

#### Manage the Nginx Process

Now that you have your web server up and running, we can go over some basic management commands.

To `start/stop/restart` your web server, you can type:

```sh
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
```

By default, Nginx is configured to start automatically when the server boots. If this is not what you want, you can disable this behavior by typing:
```sh
sudo systemctl disable nginx
```
To re-enable the service to start up at boot, you can type:
```sh
sudo systemctl enable nginx
```

### #Getting deeper

#### Server Configuration

`/etc/nginx`: The nginx configuration directory. All of the Nginx configuration files reside here.

`/etc/nginx/nginx.conf`: The main Nginx configuration file. This can be modified to make changes to the Nginx global configuration.

`/etc/nginx/sites-available/`: The directory where per-site "server blocks" can be stored. Nginx will not use the configuration files found in this directory unless they are linked to the sites-enabled directory (see below). Typically, all server block configuration is done in this directory, and then enabled by linking to the other directory.

`/etc/nginx/sites-enabled/`: The directory where enabled per-site "server blocks" are stored. Typically, these are created by linking to configuration files found in the sites-available directory.

`/etc/nginx/snippets`: This directory contains configuration fragments that can be included elsewhere in the Nginx configuration. Potentially repeatable configuration segments are good candidates for refactoring into snippets.

#### Creating Nginx VHOST

under `/etc/nginx/sites-available/` create new vhost `abc.com` with command

```sh
sudo vim /etc/nginx/sites-available/abc.com
```
Add content to new vhost
```sh
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name server_domain_or_IP;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```
Save and close then you can test your new vhost file with command `sudo nginx -t`. 

If everything go well, enable new vhost by command
`sudo a2ensite /etc/nginx/sites-available/abc.com`

And then restart nginx server `sudo systemctl reload nginx`
#### Server Logs
`/var/log/nginx/access.log`: Every request to your web server is recorded in this log file unless Nginx is configured to do otherwise.

`/var/log/nginx/error.log`: Any Nginx errors will be recorded in this log.

### Tunning Performance
[Improve the performance of your webapp: configure Nginx to cache](https://www.theodo.fr/blog/2016/06/improve-the-performance-of-your-webapp-configure-nginx-to-cache/)

[Tuning NGINX for Performance](https://www.nginx.com/blog/tuning-nginx/)

[High‑Performance Caching with NGINX and NGINX Plus](https://www.nginx.com/blog/nginx-high-performance-caching/)

