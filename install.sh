#!/bin/bash

# install dependencies
apt-get -y install build-essential zlib1g-dev libpcre3 libpcre3-dev libbz2-dev libssl-dev tar unzip wget  

BUILDDIR=/var/build/nginx
rm -r $BUILDDIR
mkdir -p $BUILDDIR

WGET='wget -nv --no-check-certificate'

# pagespeed module
cd $BUILDDIR
NPS_VERSION=1.9.32.3
$WGET https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip || (echo "download failed"; exit 1)
unzip release-${NPS_VERSION}-beta.zip
mv ngx_pagespeed-release-${NPS_VERSION}-beta pagespeed
cd pagespeed/
$WGET https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz || (echo "download failed"; exit 1)
tar -xzvf ${NPS_VERSION}.tar.gz # expands to psol/

# headers more module
cd $BUILDDIR
$WGET https://github.com/agentzh/headers-more-nginx-module/archive/v0.24.tar.gz || (echo "download failed"; exit 1)
tar -xvzf v0.24.tar.gz
mv headers-more-nginx-module-0.24 headers-more

# fix permissions
chown -R root:root $BUILDDIR

# build nginx
mkdir -p $BUILDDIR/nginx
cd $BUILDDIR/nginx
NGINXVERSION=1.6.2
$WGET http://nginx.org/download/nginx-${NGINXVERSION}.tar.gz || (echo "download failed"; exit 1)
tar -xvzf nginx-${NGINXVERSION}.tar.gz
cd nginx-${NGINXVERSION}/
./configure \
    --add-module=$BUILDDIR/pagespeed \
    --add-module=$BUILDDIR/headers-more \
    --user=www-data \
    --group=www-data \
    --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/access.log \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_spdy_module \
    --with-http_gzip_static_module

make

make install

if [[ -f /opt/cleanup.sh ]]; then
    # run in same context to inherit environment variables
    source /opt/cleanup.sh
fi
