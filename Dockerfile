ARG PHP_VERSION
FROM php:$PHP_VERSION

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer --version && php -v

RUN apt-get update && apt-get install -y --no-install-recommends git curl zip unzip  zlib1g-dev libzip-dev libmcrypt-dev libmagickwand-dev libgmp-dev libonig-dev unixodbc unixodbc-dev freetds-dev freetds-bin tdsodbc
RUN apt-get -y upgrade 
#        pdo opcache         pdo_dblib \         sockets \         shmop \        snmp \         pspell \         sysvmsg \ tidy xls        sysvsem \        sysvshm \
RUN phpModules=" \
        bcmath \
        bz2 \
        calendar \
        dba \
        exif \
        gd \
        intl \
        gettext \
        gmp \
        mbstring \
        mysqli \
        pdo_mysql \
        zip \
    " \
    && docker-php-ext-install $phpModules 

RUN pecl install igbinary \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install testing tools
RUN /usr/local/bin/composer global require phpunit/phpunit

# Install linting tools
RUN /usr/local/bin/composer global require phpmd/phpmd squizlabs/php_codesniffer

# Install static analysis tools
RUN /usr/local/bin/composer global require phpstan/phpstan vimeo/psalm phan/phan

# Install CD tools
RUN /usr/local/bin/composer global require deployer/deployer deployer/recipes

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y \
  --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g npm@latest

#Clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bash"]
