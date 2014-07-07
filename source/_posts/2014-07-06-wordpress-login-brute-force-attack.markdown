---
layout: post
title: "Wordpress防止暴力破解"
date: 2014-07-06 20:10
comments: true
categories: IT
tags: [Wordpress, Nginx]
---
很久之前突然[linode](https://www.linode.com/?r=7c8a1c7cfefbefd293f32d329292bdae55431a03)给发邮件说，CPU使用率超过阈值，然后报警了。登陆上去发现有的Wordpress进程CPU占用率特别高，看了一下access log发现几乎所有请求都在访问`/wp-login.php`。也就是有人在暴力破解。

当时在想，暴力破解Wordpress好处多多，只需要破解了一个Wordpress，在其装入一个恶意插件，然后自动去破解其他Wordpress站点，就可以像蠕虫一样蔓延开来。于是当时就加了个请求速率限制，这里记录一下。

<!-- more -->

## 防御

这个最简单的办法就是让Wordpress的主人去装个插件，在登录的时候，加上验证码，就可以基本防止大部分自动破解的程序了。不过因为我只是托管别人的Wordpress，让别人装个插件还不如自己在Nginx前端做个请求访问限制。

首先在`/etc/nginx/nginx.conf`中的http block中配置一个zone，这个zone 4MB大，平均请求速率为每分钟5个请求，因为是个人Blog的登录，所以限制那么低速，也降低了别人暴力破解的速度，按照这种速度，一分钟只能尝试5个密码，如果密码不是很废的话，要破解出来还是费时的。

```
http {
    limit_req_zone $binary_remote_addr zone=one:4m rate=5r/m;
    limit_req_status 503; 
    
    ...
}
```

然后在站点配置文件中的server block中，加上：

```
location = /wp-login.php {
    limit_req   zone=one  burst=1 nodelay;
    include fastcgi_params;
    fastcgi_pass unix:/var/run/php5-fpm.kid.sock;
}
```

具体参数解释可以围观[ngx_http_limit_req_module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html)

## 结

这样在Nginx加上登录的请求速率控制，可以在一定程度上密码被降低被暴力破解的风险，而且也不依赖Wordpress的使用人员是否安装一些保护插件。

