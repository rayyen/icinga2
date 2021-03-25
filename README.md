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


### 2.0.3

#### Upgraded

- debain update package at 2021-03-25
- icinga2:2.11.2
- icingaweb2: 2.8.2
- director: master
- doc: 2.8.2
- fileshipper: 1.2.0
- graphite: 1.1.0
- incubator: 0.6.0
- ipl: v0.5.0
- monitoring: 2.8.2
- reactbundle: 0.9.0

#### Customized

- fileshipper
    new fileshipper configuration imports.ini under /etc/icingaweb2/modules/fileshipper/imports.ini 

### 2.0.4

- merge upstream jjethwa , fix conflict and remain my customization.