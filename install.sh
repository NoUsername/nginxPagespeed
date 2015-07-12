#!/bin/bash

BUILDDIR=/var/build/nginx
rm -r $BUILDDIR
mkdir -p $BUILDDIR

WGET='wget -nv --no-check-certificate'

# pagespeed module
cd $BUILDDIR
NPS_VERSION=1.9.32.4
$WGET https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip || (echo "download failed"; exit 1)
unzip release-${NPS_VERSION}-beta.zip
mv ngx_pagespeed-release-${NPS_VERSION}-beta pagespeed
cd pagespeed/
$WGET https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz || (echo "download failed"; exit 1)
tar -xzvf ${NPS_VERSION}.tar.gz # expands to psol/

# headers more module
cd $BUILDDIR
HM_FILENAME=v0.261.tar.gz
HM_DIRNAME=headers-more-nginx-module-0.261
$WGET https://github.com/openresty/headers-more-nginx-module/archive/${HM_FILENAME} || (echo "download failed"; exit 1)
tar -xvzf ${HM_FILENAME}
mv ${HM_DIRNAME} headers-more

# fix permissions
chown -R root:root $BUILDDIR

# build nginx
mkdir -p $BUILDDIR/nginx
cd $BUILDDIR/nginx
NGINXVERSION=1.9.2
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
