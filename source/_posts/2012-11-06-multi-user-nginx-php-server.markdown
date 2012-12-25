---
comments: true
date: 2012-11-06 16:06:51
layout: post
slug: multi-user-nginx-php-server
title: 配置多用户的虚拟主机
wordpress_id: 1432
categories:
- IT
tags:
- Apache
- Linux
- Nginx
- PHP
- Wordpress
---

趁这段时间有空，换成Xen的VPS，系统装了Ubuntu 12.04。决定重新配置一下服务器，另外将Web Server从Apache换成Nginx。


## 目标


搭建一个前端为nginx支持多用户的php虚拟主机。每个站点可以跑在不同的权限的用户下，一个站点被黑的时候希望不要影响到另一个站点，或者一个同学也不要可以随意访问到别的同学的内容。


## 行动<!-- more -->




### 预备


首先创建用户，例如user01。我们可以通过

{% codeblock bash lang:bash %}
adduser user01
mkdir ~user01/www
chown user01:www-data ~user01/www
chmod 750 ~user01/www
{% endcodeblock %}

来添加用户，然后在**~user01**目录下面创建一个文件夹**www**，权限为750。group为www-data，这样，只有user01可以读写，www-data仅能读，其他人无权访问。


### php


从php 5.3.5开始就直接内置支持fpm了，建议直接安装php 5.4。使用php-fpm（php Fastcgi Process Manager），目前这样的方式运行php性能貌似是最高的。

php-fpm的配置放在/etc/php5/fpm/pool.d/下面，我们只需要以.conf结尾命名我们的配置文件就行了，具体可以参考默认的www.conf文件。例如下面文件**user01.conf**

{% codeblock ini lang:ini %}
[user01]
user = user01
group = user01
listen = /var/run/php5-fpm.user01.sock
pm = dynamic
pm.max_children = 5
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
{% endcodeblock %}

定义了php进程的权限为user01，监听文件为**/var/run/php5-fpm.user01.sock**。
这里的定义实际上是指的是用**/var/run/php5-fpm.user01.sock**这个来处理php时的权限为**user01**。到此为止，php的配置就完成了。


### nginx


我们nginx的权限为www-data，这样可以读～user01/www目录的内容，但是不能写。nginx的站点配置比较简单。我们来看一下可以工作的简单的配置：

{% codeblock nginx lang:nginx %}
server {
    server_name user01.everet.org;

    access_log  /var/log/nginx/user01.everet.org.access.log;
    error_log   /var/log/nginx/user01.everet.org.error.log;

    root    /home/user01/www/;
    index   index.php;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ .php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php5-fpm.user01.sock;
    }
}
{% endcodeblock %}

也就是当处理到.php结尾的uri时，传递到**/var/run/php5-fpm.user01.sock**这个unix套接字处理，此时的php脚本的权限为user01。如果配置得当，就不会影响到其他用户。


### wordpress


我们用php的主要原因是wordpress，wordpress默认情况下非常臃肿，运行缓慢。因为页面基本只是在更新文章或者发表评论才会更新，所以平时不需要总是动态生成页面。对此，WP Super Cache插件可以很好地进行缓存。WP Super Cache有两种缓存模式一种是PHP缓存、另一种是mod_rewrite缓存（我们选择这个），mod_rewrite是生成静态的页面文件，然后通过.htaccess文件控制Apache来rewrite url。例如我们访问[http://everet.org/2012/01/scar.html](http://everet.org/2012/01/scar.html)，其中uri为/2012/01/scar.html，进入到Apache通过rewrite后就变成了/wp-content/cache/supercache/everet.org/2012/01/scar.html/index.html，然后就可以读取静态文件返回给浏览器了。如果静态文件存在的话，就不需要经过php处理了，否则就调用php动态生成页面，同时插件还会生成那个页面的静态文件，下次就直接读取那个静态文件。

对于Apache，WP Super Cache插件生成的.htaccess可以很好的工作。然而，对于nginx，我们需要手写配置，以将uri映射的静态文件上面。我们来看一下下面的配置，这个是[Rahul Bansal](http://rtcamp.com/author/rahul-bansal/)大牛的配置，我们拿来用一下。

{% codeblock bash lang:bash %}
server {
    server_name user01.everet.org;

    access_log 	/var/log/nginx/user01.everet.org.access.log;
    error_log 	/var/log/nginx/user01.everet.org.error.log;

    root	/home/user01/www/;
    index   index.php;

    set $cache_uri $request_uri;

    if ($request_method = POST) {
        set $cache_uri "null cache";
    }
    if ($query_string != "") {
        set $cache_uri "null cache";
    }

    if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
        set $cache_uri "null cache";
    }

    if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_logged_in") {
        set $cache_uri "null cache";
    }

    location / {
        try_files /wp-content/cache/supercache/$http_host/$cache_uri/index.html $uri $uri/ /index.php;
    }

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        log_not_found off;
        access_log off;
    }

    location ~ .php$ {
        try_files $uri /index.php;
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php5-fpm.user01.sock;
    }	

    location ~* .(ogg|ogv|svg|svgz|oet|otf|woff|mp4|ttf|css|rss|atom|js|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|mp3|bmp|rtf)$ {
        expires max;
        log_not_found off;
        access_log off;
    }
}
{% endcodeblock %}

我们来慢慢阅读一下这个配置。首先，`set $cache_uri $request_uri`就是将请求的uri保存到我们的变量`$cache_uri`中。然后，如果请求方法是POST（`$request_method = POST`）、包含请求字符串（`$query_string != ""`）、请求的uri包含一些特殊的php文件（`$request_url ~* "(/wp-admin/|.........`）或者登录过评论过（通过cookie判断，`$http_cookie ~* "comment_author|w............"`），就将`$cache_uri`设置为'null cache'，这样是让`$cache_uri`这个字符串变量变成一个无意义的字符串，以让后面拼接出来的路径无意义。

对于 `try_files /wp-content/cache/supercache/$http_host/$cache_uri/index.html $uri $uri/ /index.php;`

这个是依次尝试访问这些文件，成功就直接返回不再继续，如果都找不到就返回最后一个文件/index.php。我们还记得WP Super Cache生成的静态文件结构是`/wp-content/cache/supercache/everet.org/2012/01/scar.html/index.html`，也就是先尝试WP Super Cache生成的缓存，有就直接返回缓存。

用ab测试了一下，对于缓存后的博客文章的RPS可以到900，还挺快的啊。

另外，对于wordpress的wp-config.php文件，里面写有数据库的帐号和密码，所以我们需要将权限改为600，即只有user01自己能够读写，其他人无权访问。


## 参考资料
	
  * [WordPress-Nginx + WP Super cache](http://rtcamp.com/tutorials/wordpress-nginx-wp-super-cache/)


