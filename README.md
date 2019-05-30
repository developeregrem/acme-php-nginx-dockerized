
# acme-php-nginx-dockerized
This docker-compose setup will provide a full web stack containing:

 - [nginx](https://hub.docker.com/_/nginx/) as web server or reverse proxy
 - [mariadb](https://hub.docker.com/_/mariadb) as database management system
 - [PHP 7.3-fpm-alpine](https://hub.docker.com/_/php/) with [composer](https://hub.docker.com/_/composer)
 - [redis](https://hub.docker.com/_/redis) as in-memory cache
 - ACME for letsencrypt or self-signed certificates (with automatic renew)
 - [PHPMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin)
 
The web server and php config contains some security best-practices already (e.g. recommended ciphers by [bettercrypto.org](https://bettercrypto.org/#_nginx) and disabled version banners in response headers).

## First steps

 1. After cloning the repository to e.g. /opt/ edit the `.env` file to your needs. E.g. add your hostname and set strong passwords for database accounts. You can decide whether to obtain a letsencrypt certificate or generate a self-signed (e.g. when using it in your local network).
 2. Run the following commands
`docker-compose pull`
`docker-compose build --force-rm --pull`
`docker-compose up --force-recreate -d`
Now, all containers should be up and running.
 3. Afterwards, the SSL certificate needs to be generated:
 `docker-compose exec acme /bin/sh`
 `./run.sh`
 `press Ctrl + d to exit the container and return to your host shell`
 Once this is done the acme container will run a daily cron job and check whether the certificate needs to be automatically renewed.
 
 **Please note:** when you use a self-signed certificate you need to remove the HSTS Header `Strict-Transport-Security` in the file [header.snippet](https://github.com/developeregrem/acme-php-nginx-dockerized/blob/master/conf/nginx/snippets/header.snippet) otherwise you won't be able to access your site.
 
 4. (optional) If you want to perform database backups periodically, I recommend creating a separate db user for this task:
 `docker-compose exec db/bin/sh`
 `mysql -uroot -p` 
 enter root password defined in `.env` file and execute the following SQL statement by replacing `<backupuser>` and `<pw>` with the values from your `.env` file:
 `GRANT LOCK TABLES, SELECT ON *.* TO '<backupuser>'@'%' IDENTIFIED BY '<pw>';`
 
 5. Test your setup by e.g. creating an `info.php` file with the following content
 `<?php phpinfo(); ?>`
 and place this file in your www root folder (defined in `.env` file).
 Request this file with a browser: `https://yourdomain.tld/info.php`
 
## DB Backups
 When you want to perform automatic database backup you can use the script `backup-db.sh` from this repo.
 The script will execute a backup of the database defined in `.env` file and by default stores the backup in the following folder (relative to the docker-compose setup)
 `../dbbackup`
 It is recommended to setup a cron job which calls the `backup-db.sh` script. You can use the example in the folder `cron.d/`
 When using this setup a backup will be performed once a day by keeping the last 6 backups. Older backups will be overwritten.
 
## Image Updates
It is also recommended to update the docker images on a regular base (nginx, php, etc.). For this purpose you can use the script `update-docker.sh`. To setup a cron job you can use the example in the folder `cron.d/`.

## PHP Modules
The PHP Dockerfile has some additional modules already installed. The current PHP image can be used, for example, when you use compose to manage your php dependencies and you want to use redis as an in-memory data structure as a database cache or to store php sessions, e.g. in combination with a symfony 4 project.
For a complete list of installed modules see the [Dockerfile](https://github.com/developeregrem/acme-php-nginx-dockerized/blob/master/Dockerfiles/php7fpm/Dockerfile).
