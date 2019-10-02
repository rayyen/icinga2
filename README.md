# icinga2

    this image folked from https://github.com/jjethwa/icinga2.

    docker pull aceritscloud/icinga2-base:tagname

## Image details

the main different between this repo and jjethwa as follow. for detail configuration, available environment configuration please check https://github.com/jjethwa/icinga2 

### 1.0.x

1. 1.0.x based on debian:stretch
2. Support MySQL 8.0

### 2.0.0

1. 2.0.0 base on debian:buster
2. Support MySQL 8.0
3. supervisor

### 2.0.1

1. mSMTP:
   please mount msmtprc into /etc/msmtprc, you can find msmtprc example in etc/msmtprc

