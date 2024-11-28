ARG PHP_VERSION
FROM php:$PHP_VERSION

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer --version && php -v

RUN apt-get update && apt-get install -y --no-install-recommends git curl zip unzip  \
zlib1g-dev libzip-dev libmcrypt-dev libmagickwand-dev libgmp-dev libonig-dev unixodbc unixodbc-dev freetds-dev rsync freetds-bin tdsodbc \
tini \
    unzip \
    vim \
     apt-transport-https \
      git \
     openssh-client \
    xz-utils \
    software-properties-common \
    zip \
     default-mysql-client \
    zsh 
    
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
RUN phpModules="Imagick/imagick@65e27f2bc0" 
    && docker-php-ext-install $phpModules 
RUN pecl install igbinary 
#    && pecl install imagick \
#    && docker-php-ext-enable imagick
#ARG IMAGICK_VERSION=3.7.0

# Imagick is installed from the archive because regular installation fails
# See: https://github.com/Imagick/imagick/issues/643#issuecomment-1834361716
#RUN curl -L -o /tmp/imagick.tar.gz https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz \
#    && tar --strip-components=1 -xf /tmp/imagick.tar.gz \
#    && phpize \
#    && ./configure \
#    && make \
#    && make install \
#    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
#    && rm -rf /tmp/*
#    # <<< End of Imagick installation
#RUN docker-php-ext-enable imagick

# Install linting tools
RUN composer global require phpunit/phpunit phpmd/phpmd squizlabs/php_codesniffer deployer/deployer

# Install static analysis tools
#RUN composer global require phpstan/phpstan vimeo/psalm phan/phan

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y \
  --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g npm@latest
RUN npm install -g pnpm

RUN  apt-get autoremove -y --purge \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/cache/debconf/*-old \
  && rm -rf /usr/share/doc/* \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/*

CMD ["bash"]
