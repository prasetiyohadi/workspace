---
layout: single
title: "Installing Nginx on CentOS 6.5"
date: 2014-02-09
categories:
  - sysadmin
comments: true
---

CentOS community now works together with Redhat alongside Fedora. It's good
news. So, we can hope to get a better software and support for next release of
our beloved CentOS. As one of Linux (CentOS) fan, I want to share my experience
installing nginx (engine-x) in CentOS 6.5. My VPS was installed as minimal
server and then I added new packages, such as "Development tools" group and new
repos (EPEL, CentALT).

![nginx logo](http://nginx.org/nginx.gif) in CentOS 6.5

First thing that I usually do before doing something is researching, usually.
So, before I install nginx, I searched for tutorials and I found one in
<http://www.howtoforge.com/installing-nginx-with-php5-and-php-fpm-and-mysql-support-on-ubuntu-11.10>.
But, it is for Ubuntu and with MySQL which we not really need, yet. It is okay,
because this is the _fun_ part. We get to find the right configuration for
our Linux distros.

The easiest way to install a package in CentOS (or every Linux distro) is using
package manager, like **yum**. So, I searched <http://pkgs.org> to find any
nginx package for CentOS and I found the latest stable nginx in CentALT
repository.

    # yum --enablerepo=CentALT install nginx-stable
    # /etc/rc.d/init.d/nginx start

Open a browser and open our web server. _Voila!_

![running-nginx](images/nginx-1.PNG)

We got a running nginx on CentOS. But, it is _not everything_ yet. Now, we will
make our nginx run PHP so we install **php-fpm**, a FastCGI Process Manager.

    # yum install php-fpm
    # /etc/rc.d/init.d/php-fpm start

The \*\*php-fpm\*\* daemon will start at localhost on port 9000. The nginx
configuration is easy to understand and available at
<http://wiki.codemongers.com/NginxFullExample> and
<http://wiki.codemongers.com/NginxFullExample2>. Then, to make nginx can
execute PHP files, we need to make some changes in nginx configuration file
_/etc/nginx/nginx.conf_

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
     root           html;
     fastcgi_pass   127.0.0.1:9000;
     fastcgi_index  index.php;
     fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
     include        fastcgi_params;
    }

Reload nginx.

    # /etc/rc.d/init.d/nginx reload

To test if the FastCGI server works, create the following PHP file in document root.

    <?php
     phpinfo();
    ?>

Save file as _info.php_ and call that file in a browser.

![running-php](images/fastcgi.PNG)

If it's showing the PHP information, our installation is running nicely.
