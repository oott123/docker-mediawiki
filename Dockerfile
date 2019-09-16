FROM mediawiki:1.33

COPY start.sh /bin/start.sh
COPY runjobs.sh /bin/runjobs.sh

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
  printf "\n" | pecl install mcrypt-1.0.2 && \
  docker-php-ext-enable mcrypt && \
  docker-php-ext-install -j$(nproc) iconv && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-install -j$(nproc) gd mbstring && \
  apt-get install -y libmagickwand-dev --no-install-recommends && \
  printf "\n" | pecl install imagick && \
  docker-php-ext-enable imagick && \
  docker-php-source delete && \
  chmod +x /bin/start.sh && \
  chmod +x /bin/runjobs.sh && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  rm -rf /var/lib/apt/lists/*

CMD [ "/bin/start.sh" ]
