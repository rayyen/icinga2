# icinga2

This repository contains the source for the [icinga2](https://www.icinga.org/icinga2/) [docker](https://www.docker.com) image.

The dockerhub-repository is located at [https://hub.docker.com/r/jordan/icinga2/](https://hub.docker.com/r/jordan/icinga2/).

This build is automated by push for the git-repo. Just crawl it via:

    docker pull jordan/icinga2

## Image details

1. Based on debian:buster
1. Key-Features:
   - icinga2
   - icingacli
   - icingaweb2
   - icingaweb2-director module
   - icingaweb2-graphite module
   - icingaweb2-module-aws
   - ssmtp
   - MySQL
   - Supervisor
   - Apache2
   - SSL Support
   - Custom CA support
1. No SSH. Use docker [exec](https://docs.docker.com/engine/reference/commandline/exec/) or [nsenter](https://github.com/jpetazzo/nsenter)
1. If passwords are not supplied, they will be randomly generated and shown via stdout.

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


#### Msmtp Configration

use data field to switch smtp account id in msmtprc

1. add DataField msmtp_account_id
2. at notification template add new field(custom_properties) -m) $notification.vars.msmtp_account$


docker run -p 80:80 -p 443:443 -e DEFAULT_MYSQL_PASS=5tgb6yhn -e MYSQL_ROOT_PASSWORD=5tgb6yhn -e ICINGA2_FEATURE_DIRECTOR_PASS=5tgb6yhn -t 8f03e82eb4c5


#### Debug

docker run -it --entrypoint /bin/bash $IMAGE_NAME -s
