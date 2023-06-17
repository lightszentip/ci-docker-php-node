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

RUN pecl install igbinary \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install testing tools
RUN composer global require phpunit/phpunit

# Install linting tools
RUN composer global require phpmd/phpmd squizlabs/php_codesniffer

# Install static analysis tools
#RUN composer global require phpstan/phpstan vimeo/psalm phan/phan

# Install CD tools
RUN composer global require deployer/deployer

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y \
  --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g npm@latest
RUN npx npkill

#Clean
RUN  apt-get autoremove -y --purge \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/cache/debconf/*-old \
  && rm -rf /usr/share/doc/* \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/*

CMD ["bash"]
