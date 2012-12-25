---
comments: true
date: 2012-02-11 19:50:09
layout: post
published: false
slug: site-is-down
title: 悲剧啊，我的网站今天宕机了
wordpress_id: 520
categories:
- Life
---

吃饭完回来看到监控邮件发来我的网站**不可用(403 Forbidden)，**有图有真相。

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb1.png)](http://everet.org/wp-content/uploads/2012/02/image1.png)

然后一访问，还真的不行了啊，返回一个403。

不过发现挂在服务器的上的其他的4个网站都没有问题.包括同域名的[http://spead.everet.org](http://spead.everet.org)的俊杰的博客都没有问题，唯独我的出了问题，还真是奇葩了。

我从[www.everet.org](http://www.everet.org)访问会跳到everet.org，说明wordpress是可以运行了，只是everet.org这个域名出了问题，而且我在吃饭啥也没动，还真是奇葩了啊。看上去应该是apache出了问题。<!-- more -->

仔细看了配置，貌似也没啥问题，想想应该是有个default的配置可能和现在的突然不兼容了，然后就把它禁用了，然后reload一下apache就发现everet.org可以访问了。

与此同时还收到了邮件~ 看来监控宝还真是有用的。

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb2.png)](http://everet.org/wp-content/uploads/2012/02/image2.png)

啊~真是无语啊~~
