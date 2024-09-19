# Dockerfile for icinga2 with icingaweb2
# https://github.com/jjethwa/icinga2
FROM jordan/icinga2:latest


# ## DIFFER-UPPSTREAM mSMTP Configuration
# COPY etc/mail.rc /etc/mail.rc
# COPY msmtp/msmtprc /etc/msmtprc
# COPY msmtp/aliases /etc/aliases


# RUN mkdir -p /var/log/msmtprc/ \
#   && chown nagios:nagios /etc/msmtprc \
#   && chmod 600 /etc/msmtprc

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    apache2 \
    ca-certificates \
    apt-transport-https \
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
    ssmtp \
    sudo \
    supervisor \
    unzip \
    wget \
    git \
    vim \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip \
  && python3 -m pip install cryptography paramiko icinga2api PyMySQL ujson
  

EXPOSE 80 443 5665

# Initialize and run Supervisor
ENTRYPOINT ["/opt/run"]
