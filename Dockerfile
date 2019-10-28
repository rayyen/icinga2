# Dockerfile for icinga2 with icingaweb2
# https://github.com/jjethwa/icinga2

FROM debian:buster

ENV APACHE2_HTTP=REDIRECT \
    ICINGA2_FEATURE_GRAPHITE=false \
    ICINGA2_FEATURE_GRAPHITE_HOST=graphite \
    ICINGA2_FEATURE_GRAPHITE_PORT=2003 \
    ICINGA2_FEATURE_GRAPHITE_URL=http://graphite-service \
    ICINGA2_USER_FULLNAME="Icinga2" \
    ICINGA2_FEATURE_DIRECTOR="true" \
    ICINGA2_FEATURE_DIRECTOR_KICKSTART="true" \
    ICINGA2_FEATURE_DIRECTOR_USER="icinga2-director" \
    DEBIAN_FRONTEND=noninteractive

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y --no-install-recommends \
      apache2 \
      ca-certificates \
      curl \
      dnsutils \
      file \
      gnupg \
      libdbd-mysql-perl \
      libdigest-hmac-perl \
      libnet-snmp-perl \
      locales \
      lsb-release \
      mailutils \
      mariadb-client \
      mariadb-server \
      netbase \
      openssh-client \
      openssl \
      php-curl \
      php-ldap \
      php-mysql \
      procps \
      pwgen \
      snmp \
      msmtp \
      msmtp-mta \
      s-nail \
      sudo \
      supervisor \
      unzip \
      wget \
      git \
      vim \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN export DEBIAN_FRONTEND=noninteractive \
 && curl -s https://packages.icinga.com/icinga.key \
 | apt-key add - \
 && echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/icinga2.list \
 && echo "deb http://packages.icinga.org/debian icinga-$(lsb_release -cs) main" > /etc/apt/sources.list.d/icinga2.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      icinga2 \
      icinga2-ido-mysql \
      icingacli \
      icingaweb2 \
      icingaweb2-module-doc \
      icingaweb2-module-monitoring \
      monitoring-plugins \
      nagios-nrpe-plugin \
      nagios-plugins-contrib \
      nagios-snmp-plugins \
      libmonitoring-plugin-perl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG GITREF_DIRECTOR=master
ARG GITREF_MODGRAPHITE=master
ARG GITREF_MODAWS=master

RUN mkdir -p /usr/local/share/icingaweb2/modules/ \
# Icinga Director
 && mkdir -p /usr/local/share/icingaweb2/modules/director/ \
 && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-director/archive/${GITREF_DIRECTOR}.tar.gz" \
 | tar xz --strip-components=1 --directory=/usr/local/share/icingaweb2/modules/director --exclude=.gitignore -f - \
# Icingaweb2 Graphite
 && mkdir -p /usr/local/share/icingaweb2/modules/graphite \
 && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-graphite/archive/${GITREF_MODGRAPHITE}.tar.gz" \
 | tar xz --strip-components=1 --directory=/usr/local/share/icingaweb2/modules/graphite -f - icingaweb2-module-graphite-${GITREF_MODGRAPHITE}/ \
# reactbundle
 && mkdir -p /usr/local/share/icingaweb2/modules/reactbundle \
 && wget -q https://github.com/Icinga/icingaweb2-module-reactbundle/archive/v0.7.0.tar.gz -O - \
   |  tar xfz - -C /usr/local/share/icingaweb2/modules/reactbundle --strip-components=1  \
 # ipl
 && mkdir /usr/local/share/icingaweb2/modules/ipl \
 && wget -q https://github.com/Icinga/icingaweb2-module-ipl/archive/v0.4.0.tar.gz -O - \
   | tar xfz - -C /usr/local/share/icingaweb2/modules/ipl --strip-components=1 \
# incubator
 && mkdir /usr/local/share/icingaweb2/modules/incubator \
 && wget -q https://github.com/Icinga/icingaweb2-module-incubator/archive/v0.5.0.tar.gz -O - \
   | tar xfz - -C /usr/local/share/icingaweb2/modules/incubator --strip-components 1 

ADD content/ /

# Final fixes
RUN true \
 && sed -i 's/vars\.os.*/vars.os = "Docker"/' /etc/icinga2/conf.d/hosts.conf \
 && mv /etc/icingaweb2/ /etc/icingaweb2.dist \
 && mkdir /etc/icingaweb2 \
 && mv /etc/icinga2/ /etc/icinga2.dist \
 && mkdir /etc/icinga2 \
 && usermod -aG icingaweb2 www-data \
 && usermod -aG nagios www-data \
 && rm -rf \
     /var/lib/mysql/* \
 && chmod u+s,g+s \
     /bin/ping \
     /bin/ping6 \
     /usr/lib/nagios/plugins/check_icmp

## Unattended Upgrade Configuration
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install unattended-upgrades apt-listchanges -y \
 && echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections \
 && dpkg-reconfigure -f noninteractive unattended-upgrades 

COPY etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades

## mSMTP Configuration
COPY etc/icinga2/scripts/custom-mail-host-notification.sh /etc/icinga2/scripts/mail-host-notification.sh
COPY etc/icinga2/scripts/custom-mail-service-notification.sh /etc/icinga2/scripts/mail-service-notification.sh
COPY etc/mail.rc /etc/mail.rc
COPY etc/msmtprc /etc/msmtprc

RUN mkdir -p /var/log/msmtprc/ \
  && chown nagios:nagios /etc/msmtprc \
  && chmod 600 /etc/msmtprc


EXPOSE 80 443 5665

# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
