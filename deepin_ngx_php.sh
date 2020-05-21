#!/bin/bash

groupadd www
useradd -g www www

# 1. ngx 本地开发，直接覆盖安装
apt-get install libpcre3 libpcre3-dev openssl libssl-dev zlib1g-dev

# nginx 参考官方 http://tengine.taobao.org/nginx_docs/cn/docs/
mkdir -p /tmp/nginx && cd /tmp/nginx
wget -O ngx.tgz http://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxf ngx.tgz --strip-components 1
./configure \
    --prefix=/usr/local/nginx \
    --user=www --group=www \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_stub_status_module
#lnmp.org默认 3.
#配置参数 http://nginx.org/en/docs/configure.html
make -j8 && make install
ln -s /usr/bin/nginx /usr/local/nginx/sbin/nginx
nginx -V
./init.d/nginx restart


# 2. php7.4.x安装
mkdir -p /tmp/php7 && cd /tmp/php7
cp /home/wwwroot/cluster/php.a/packages/php.tar.xz .
tar -Jxf php.tar.xz --strip-components 1
# 产看编译参数 php -i|grep configure
## oniguruma: 安装php7.4的过程中，mbstring的正则表达式处理功能对这个包有依赖性
apt-get install \
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        libsqlite3-dev \
        libxpm-dev \
        pkg-config \
        libedit-dev \
        librabbitmq-dev \
        libmemcached-dev

mkdir oniguruma && cd oniguruma && \
    wget https://github.com/kkos/oniguruma/archive/v6.9.5.tar.gz -O oniguruma.tar.gz && \
    tar -zxf oniguruma.tgz --strip-components 1 && \
    ./autogen.sh && ./configure --prefix=/usr && \
    make -j8 && make install && \
    cd ../ && rm -rf oniguruma

./configure \
        --prefix="/usr/local/php" \
        --with-config-file-path="/usr/local/php/etc" \
        --with-config-file-scan-dir="/usr/local/php/etc/conf.d" \
        \
        --enable-mbstring \
        --enable-mbregex \
        --enable-mysqlnd \
        --with-mysqli \
        --with-pdo-mysql \
        --enable-sysvmsg \
        --enable-ftp \
        --enable-exif \
        --enable-pcntl \
        --enable-sockets \
        --enable-sysvsem \
        --enable-xml \
        --enable-bcmath \
        --with-openssl \
        --with-curl \
        --with-libedit \
        --with-zlib \
        --with-pcre-jit \
        --with-pear \
        --with-libxml \
        --enable-gd \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --with-gettext \
        --with-iconv \
        \
        --enable-fpm \
        --with-fpm-user=www \
        --with-fpm-group=www \
        --disable-cgi
make ZEND_EXTRA_LIBS='-liconv' -j8 && make install

mkdir libuuid && cd libuuid && \
    cp /home/wwwroot/cluster/php.a/packages/libuuid.tgz . && \
    tar -zxf libuuid.tgz --strip-components 1 && \
    ./configure --prefix=/usr && \
    make -j8 && make install && \
    cd ../ && rm -rf libuuid

ln -sf /usr/local/php/bin/php /usr/bin/php
ln -sf /usr/local/php/sbin/php-fpm /usr/bin/php-fpm
ln -sf /usr/local/php/bin/phpize /usr/bin/phpize
ln -sf /usr/local/php/bin/php-config /usr/bin/php-config
ln -sf /usr/local/php/bin/pecl /usr/bin/pecl
pecl channel-update pecl.php.net
pecl install igbinary amqp apcu protobuf redis uuid inotify event swoole memcached
cp php.ini /usr/local/php/etc -f
php -v && php -m
./init.d/php-fpm restart
