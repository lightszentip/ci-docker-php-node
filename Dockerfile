ARG PHP_VERISON
FROM php:$PHP_VERISON

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer --version && php -v

RUN apt-get update && apt-get install -y \
  --no-install-recommends git curl zip unzip \
  zlib1g-dev libzip-dev libmcrypt-dev \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick && apt-get -y upgrade

RUN docker-php-ext-install zip mcrypt pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y \
  --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g npm@latest
CMD ["bash"]
