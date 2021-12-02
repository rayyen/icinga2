# icinga2

This repository contains the source for the [icinga2](https://www.icinga.org/icinga2/) [docker](https://www.docker.com) image.

    docker pull aceritscloud/icinga2-its:tagname

## Image details

the main different between this repo and jjethwa as follow. for detail configuration, available environment configuration please check <https://github.com/jjethwa/icinga2>

## Usage

Start a new container and bind to host's port 80

    docker run -p 80:80 -h icinga2 -t jordan/icinga2:latest

### docker-compose

Clone the repository and create a file `secrets_sql.env`, which contains the `MYSQL_ROOT_PASSWORD` variable.

    git clone https://github.com/jjethwa/icinga2.git
    cd icinga2
    echo "MYSQL_ROOT_PASSWORD=<password>" > secrets_sql.env
    docker-compose up

This boots up an icinga(web)2 container with another MySQL container reachable on [http://localhost](http://localhost) with the default credentials *icingaadmin*:*icinga*.

### Persistence

To ensure restarts, you should set:

`DEFAULT_MYSQL_PASS`  - The database password for the icinga2 user

`MYSQL_ROOT_PASSWORD` - This is the root (admin) password for the database.  The container will try to reset the password for the icinga2 database user if this is available

This is particularly important when using the /var/lib/mysql volume or an external database

## Icinga Web 2

Icinga Web 2 can be accessed at [http://localhost/icingaweb2](http://localhost/icingaweb2) with the credentials *icingaadmin*:*icinga* (if not set differently via variables).  When using a volume for /etc/icingaweb2, make sure to set ICINGAWEB2_ADMIN_USER and ICINGAWEB2_ADMIN_PASS

### Saving PHP Sessions

If you want to save your php-sessions over multiple boots, mount `/var/lib/php/sessions/` into your container. Session files will get saved there.

example:
```
docker run [...] -v $PWD/icingaweb2-sessions:/var/lib/php/sessions/ jordan/icinga2
```

## Graphite

The graphite writer can be enabled by setting the `ICINGA2_FEATURE_GRAPHITE` variable to `true` or `1` and also supplying values for `ICINGA2_FEATURE_GRAPHITE_HOST` and `ICINGA2_FEATURE_GRAPHITE_PORT`. This container does not have graphite and the carbon daemons installed so `ICINGA2_FEATURE_GRAPHITE_HOST` should not be set to `localhost`.

Example:

```
docker run -t \
  --link graphite:graphite \
  -e ICINGA2_FEATURE_GRAPHITE=true \
  -e ICINGA2_FEATURE_GRAPHITE_HOST=graphite \
  -e ICINGA2_FEATURE_GRAPHITE_PORT=2003 \
  jordan/icinga2:latest
```

## Icinga Director

- merge upstream jjethwa , fix conflict and remain my customization.

### 2.0.5 (de)

- upgrade to r2.13.2-1

#### Msmtp Configration

use data field to switch smtp account id in msmtprc

1. add DataField msmtp_account_id
2. at notification template add new field(custom_properties) -m) $notification.vars.msmtp_account$

#### Debug

docker run -it --entrypoint /bin/bash $IMAGE_NAME -s

## Local Debug example

```bash
docker run  --name cps-db -e MYSQL_ROOT_PASSWORD=5tgb6yhn -d mysql:latest --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password 
```

```bash
docker run  -it -p 80:80 -p 444:443 -e DEFAULT_MYSQL_HOST=172.17.0.2 -e DEFAULT_MYSQL_PASS=5tgb6yhn \
-e MYSQL_ROOT_PASSWORD=5tgb6yhn \
-e ICINGA2_FEATURE_DIRECTOR_PASS=5tgb6yhn \
--name=i2 \
```

## Production example


Master
```bash
docker run --name mysql  -v /nfsmount/monitor-m1/mysql/conf:/etc/mysql/conf.d -v /nfsmount/monitor-m1/mysql/data:/var/lib/mysql -p 3306:3306 -p 33060:33060 -e MYSQL_ROOT_PASSWORD=5tgb6yhn -d  --security-opt seccomp=unconfined mysql:8.0.27 --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
 

```

```bash
docker run --name mysql-icinga -v /nfsmount/monitor-tn-s0/mysql/conf:/etc/mysql/conf.d -v /nfsmount/monitor-tn-s0/mysql/data:/var/lib/mysql -p 3306:3306 -p 33060:33060 -e MYSQL_ROOT_PASSWORD=5tgb6yhn -d mysql:8.0.27
--security-opt seccomp=unconfined --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

Master

```bash

docker run  -itd -p 5665:5665 -p 82:80 -p 444:443 -e DEFAULT_MYSQL_HOST=172.17.0.2 -e DEFAULT_MYSQL_PASS=5tgb6yhn \
-e MYSQL_ROOT_PASSWORD=5tgb6yhn \
-e ICINGA2_FEATURE_DIRECTOR_PASS=5tgb6yhn \
-v /nfsmount/monitor-m1/icinga2/ssmtp:/etc/ssmtp \
-v /nfsmount/projects/icinga2-tools/:/usr/local/share/icinga2-tools \
-v /nfsmount/monitor-m1/icinga2/var/lib/icinga2/:/var/lib/icinga2/ \
-v /nfsmount/monitor-m1/icinga2/conf:/etc/icinga2 \
-v /nfsmount/monitor-m1/icinga2/webconf:/etc/icingaweb2 \
--mount type=bind,source=/nfsmount/monitor-m1/etc/msmtprc,target=/etc/msmtprc \
-v /nfsmount/monitor-m1/etc/icinga2/features-enabled:/etc/icinga2/features-enabled \
--hostname monitor-m1.acerits.net \
--name m1 \
--security-opt seccomp=unconfined \
-t aceritscloud/icinga2-its:2.0.7s
```

TN0

```bash
docker run  -itd -p 5665:5665 -p 82:80 -p 444:443 -e DEFAULT_MYSQL_HOST=172.17.0.2 -e DEFAULT_MYSQL_PASS=5tgb6yhn \
-e MYSQL_ROOT_PASSWORD=5tgb6yhn \
-e ICINGA2_FEATURE_DIRECTOR_PASS=5tgb6yhn \
-v /nfsmount/monitor-tn1/icinga2/ssmtp:/etc/ssmtp \
-v /nfsmount/projects/icinga2-tools/:/usr/local/share/icinga2-tools \
-v /nfsmount/monitor-tn1/icinga2/var/lib/icinga2/:/var/lib/icinga2/ \
-v /nfsmount/monitor-tn1/icinga2/conf:/etc/icinga2 \
-v /nfsmount/monitor-tn1/icinga2/webconf:/etc/icingaweb2 \
--mount type=bind,source=/nfsmount/monitor-tn1/etc/msmtprc,target=/etc/msmtprc \
-v /nfsmount/monitor-tn1/etc/icinga2/features-enabled:/etc/icinga2/features-enabled \
--hostname monitor-tn1.acerits.net \
--name m1 \
--security-opt seccomp=unconfined \
-t aceritscloud/icinga2-its:2.0.7s
```

CREATE DATABASE IF NOT EXISTS icinga2idomysql;
   CREATE USER IF NOT EXISTS 'icinga2'@'localhost'
     IDENTIFIED BY '5tgb6yhn';
   GRANT ALL
     ON icinga2idomysql.*
     TO 'icinga2'@'localhost';

UPDATE mysql.user SET Password=PASSWORD('5tgb6yhn') WHERE User='icinga2';

### DockerHub
aceritscloud
Kec370$$$


curl -H 'Accept: application/json' \
     -u 'icinga2-director:5tgb6yhn' \
     'https://monitor-m1.acerits.net/icingaweb2/director/host?name=hostname.example.com'


