FROM mediawiki:1.33
RUN docker-php-source extract && \
  apt-get update && \
  apt-get install -y curl wget librsvg2-dev librsvg2-bin unzip sudo && \
  apt-get install -y liblua5.1-0-dev && \
  wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer && \
  chmod +x /usr/local/bin/composer && \
  git clone https://gerrit.wikimedia.org/r/mediawiki/php/luasandbox.git /usr/local/src/luasandbox && \
  docker-php-ext-configure /usr/local/src/luasandbox && \
  docker-php-ext-install /usr/local/src/luasandbox && \
  rm -rf /usr/local/src/luasandbox && \
  apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev && \
  docker-php-ext-install -j$(nproc) iconv mcrypt && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-install -j$(nproc) gd mbstring && \
  apt-get install -y libmagickwand-dev --no-install-recommends && \
  printf "\n" | pecl install imagick && \
  docker-php-ext-enable imagick && \
  docker-php-source delete && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  rm -rf /var/lib/apt/lists/*
