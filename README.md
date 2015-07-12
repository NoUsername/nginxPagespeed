# Nginx with ngx_pagespeed and ngx_headers_more modules

recommended way to use this:

Simply mount your configuration directory of your host to the container.

Make sure you have: `daemon off;` in your main `nginx.conf` file! Otherwise the container will exit immediately.

Then run with:

```
sudo docker run --name nginxDocker --net=host -v /etc/nginx:/etc/nginx -v /var/www:/var/www nousername/nginxpagespeed:NGX1.9.2_MPS1.9.32.4
```

