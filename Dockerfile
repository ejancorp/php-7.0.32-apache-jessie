FROM php:7.0.32-apache-jessie

RUN apt-get update \
    && apt-get install -y \ 
        libxslt-dev \
        zlib1g-dev \
        libpng-dev \
        libssh2-1-dev \
        libssh2-1 \
        libxml2-dev \
        git \
        zip \
        unzip \
        wget

# Install ssh2 from source
RUN wget https://github.com/Sean-Der/pecl-networking-ssh2/archive/php7.zip -O pecl-networking-ssh2-php7.zip \
    && unzip pecl-networking-ssh2-php7.zip \
    && rm -rf pecl-networking-ssh2-php7.zip \
    && cd pecl-networking-ssh2-php7 \
    && phpize \
    && ./configure \
    && make \
    && make install \ 
    && cd ../

RUN docker-php-ext-enable ssh2 
RUN docker-php-ext-install calendar exif gd gettext mysqli pcntl pdo_mysql shmop soap sockets sysvmsg sysvsem sysvshm wddx xsl zip opcache

RUN apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src

RUN a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod env \
    && a2enmod headers \
    && a2enmod expires \
    && a2enmod cache \
    && a2enmod cache_disk \
    && a2enmod proxy \
    && a2enmod proxy_http