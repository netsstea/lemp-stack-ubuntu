# Installing LEMP Stack

**Last update**: 20/65/2018, tested on Ubuntu 18.04

## Overview

I am lazy guy so when I have to re-install LEMP stack many times I felt it wrong. So I wrote these bash scripts to help saving time while installing LEMP stack.
Best option is go with Docker and its images.

The LEMP scripts consists of:

- Nginx
- Apache
- PHP7.2 and its dependencies
- MariaDB
- Composer
- NodeJS
- Redis
- MongoDB

## Scripts
1. Full LEMP stack (Nginx + PHP7.2 + MariaDB + Redis + MongoDB + Composer)
    [full-stack.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/full-stack.sh)
1. Nginx + PHP 7.2 + MariaDB
    [php7.2-nginx-mariadb.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/php7.2-nginx-mariadb.sh)
1. Apache2 + PHP 7.2 + MariaDB
    [php7.2-apache2-mariadb.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/php7.2-apache2-mariadb.sh)
1. Composer
    [composer.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/composer.sh)
1. Redis and PHP-Redis
    [redis.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/redis.sh)
1. MongoDB and PHP-Mongo
    [mongo.sh](https://github.com/netsstea/lemp-stack-ubuntu/blob/master/mongo.sh)