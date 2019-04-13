ARG PHP_VERSION=${PHP_VERSION}
FROM php:${PHP_VERSION}-fpm
MAINTAINER Jesus Dominguez <j.dominguez@kodeline.com>

RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  mysql-client \
  vim \
  zip \
  procps \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  gd \
  intl \
  mbstring \
  mcrypt \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip

RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 app \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

COPY configs/php-fpm/sshd/insecure_id_rsa /tmp/id_rsa
COPY configs/php-fpm/sshd/insecure_id_rsa.pub /tmp/id_rsa.pub

RUN apt-get update \
    && apt-get install -y openssh-server openssh-sftp-server \
    && rm -f /etc/service/sshd/down \
    && mkdir -p /run/sshd \
    && mkdir -p /root/.ssh \
    && cat /tmp/id_rsa.pub > /root/.ssh/authorized_keys \
    && cat /tmp/id_rsa.pub > /root/.ssh/id_rsa.pub \
    && cat /tmp/id_rsa > /root/.ssh/id_rsa \
    && rm -f /tmp/id_rsa* \
    && chmod 600 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
    && chmod 400 /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/authorized_keys \
    && sed -i "s/root:!/root:*/" /etc/shadow \
    && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && ssh-keygen -A

COPY configs/php-fpm/www.conf /usr/local/etc/php-fpm.d/
COPY configs/php-fpm/php.ini /usr/local/etc/php/
COPY configs/php-fpm/xdebug.ini /usr/local/etc/php/conf.d/
COPY configs/php-fpm/php-fpm.conf /usr/local/etc/
COPY configs/php-fpm/sshd/sshd_config /etc/ssh/sshd_config

RUN chown -R app:app /usr/local/etc/php/conf.d
RUN mkdir -p /var/www && chown -R app:app /var/www/
RUN echo "app ALL=(ALL) NOPASSWD: /bin/chown" >> /etc/sudoers.d/app && \
    echo "app ALL=(ALL) NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers.d/app

USER app:app

VOLUME /app

WORKDIR /app

EXPOSE 9001

COPY images/php-fpm/entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "php-fpm" ]
