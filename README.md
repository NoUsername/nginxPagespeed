# Nginx with ngx_pagespeed and ngx_headers_more modules

recommended way to use this:

Simply mount your configuration directory of your host to the container.

Then run with:

```
sudo docker run -d --name nginxDocker --net=host -v /etc/nginx:/etc/nginx -v /var/www:/var/www nousername/nginxpagespeed:stable
```

If you want to be able to access (and purge?) the logs easily, consider also mapping the containers `/var/log/nginx` directory to your host.

If you want to run nginx from the container directly (without the provided entrypoint script), make sure you either have `daemon: off;` in your `nginx.conf` or pass it via the commandline (`nginx -g "daemon off;"`). 

## Security

Feel free to include

```
user www-data;
```

in your `nginx.conf` file, this user is part of the default debian installation which this container is based on