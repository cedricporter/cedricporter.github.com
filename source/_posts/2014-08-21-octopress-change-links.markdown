---
layout: post
title: "无痛修改Octopress文章链接"
date: 2014-08-21 21:33
comments: true
categories: IT
tags: [Nginx, Octopress]
---
我的Blog的文章的链接本来是类似<http://everet.org/2013/02/thinking-of-emacs.html>这样的，不过觉得发布的时间戳加到url中，对老文章的SEO不利。所以决定将其去掉，改为<http://everet.org/thinking-of-emacs.html>。

另一个是我想缩短下文章url的长度。

不过缩短url会遇到两个大问题，第一个是原来发出去的原来的文章链接会404，第二个是评论系统Disqus是根据文章url来作为评论的标识符。

不过好在是有无痛的解决方案，我们来各个击破。

<!-- more -->

首先我们要去掉时间戳，这个非常容易，修改`_config.yml`。

``` diff _config.yml diff
- permalink: /:year/:month/:title.html
+ permalink: /:title.html
```

这样就可以将让Octopress生成文章的时候去掉时间戳，只保留文章标题。

不过如果此时就止步的话，原来的链接访问都会404，而且评论全部都会不见了。所以我们需要做一些处理。

## 301重定向原url

HTTP Code的301的意思是`301 Moved Permanently`。

我的Blog是用Nginx来服务Blog的文件，我们可以让Nginx在访问原来的url的时候，301重定向到新的地址。我们加上以下配置，通过正则表达式匹配，找出文章标题，然后重写url。

``` nginx nginx配置
location ~* ^/\d+/\d+/.+\.html$ {
    rewrite ^/\d+/\d+/(.+\.html)$ /$1 permanent;
}
```

然后我们访问旧的文章链接的时候，就会301重定向到新的文章地址了。这样旧的文章地址就不会404了。

## Disqus的评论
刚刚说到Disqus的评论是根据文章url来标识的，我们改了url，评论就会不见了。不过好在Disqus的Admin设置有个爬虫，`Discussions`->`Tools`->`Start Crawler`，他可以根据301重定向自动更新原来的评论的标志，也就是新的url也可以看到之前url的评论了。

打完收工！


