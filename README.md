# icinga2

    this image folked from https://github.com/jjethwa/icinga2.

    docker pull aceritscloud/icinga2-base:tagname

## Image details

the main different between this repo and jjethwa as follow. for detail configuration, available environment configuration please check https://github.com/jjethwa/icinga2 

---

### 1.0.x

#### Changed

- 1.0.x based on debian:stretch
- Support MySQL 8.0

---

### 2.0.0

#### Changed

- 2.0.0 base on debian:buster
- Support MySQL 8.0
- supervisor

---

### 2.0.1

#### Changed

- mSMTP:
   please mount msmtprc into /etc/msmtprc, you can find msmtprc example in ./etc/msmtprc

---

### 2.0.2

#### Upgraded

- icinga2:2.11.2
- icingaweb2-module-reactbundle:0.7.0
- icingaweb2-module-incubator:0.5.0
- icingaweb2-module-ipl:0.4.0