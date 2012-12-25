---
comments: true
date: 2012-02-10 15:23:41
layout: post
slug: server-migration
title: 服务器迁移告一段落
wordpress_id: 501
categories:
- Life
tags:
- Apache
- Git
- Linux
- Python
- Web
---

原来的主机是基于Xen的，价格非常的贵，于是现在换了基于OpenVZ的burst.net的主机，性能虽然可能比不上原来的，但是便宜了不少。内存从128MB换成了512MB，不过价格便宜了一半。感觉速度还是**快**了很多很多啊~而且还有原生的**ipv6**的支持，不再需要借助tunnelbreaker，真是校网的救星。

不过想起昨天还真是悲剧，开通了10分钟84就将账号发给我，但是竟然没有ip地址，这真是奇葩啊。于是发了ticket就去闲逛了，我们比他们晚13个小时，他们上午8点上班，也就是我们的晚上9点。于是晚上9点多就有人回复解决了问题，把问题修复了，并且把ip重新发了。然后技术支持很好心的问了还有什么需要帮忙，然后就再顺便帮忙分配了一些ipv6的地址。

[![](http://everet.org/wp-content/uploads/2012/02/QQ截图20120210155314-640x578.jpg)](http://everet.org/wp-content/uploads/2012/02/QQ截图20120210155314.jpg)

于是今天开工迁移了。这次将网站都迁移过去了，等过几天再把Git版本库也迁移过去。

原来的主机用的是nginx（发音同 engine x），换到burst.net后默认就装了apache，于是就决定换回apache了，重新配置了下换成worker模式，感觉和nginx差不多吧。

在如下python写的简单的压力测试下服务器基本也没什么压力。<!-- more -->


{% codeblock python lang:python %}

#!/usr/bin/python
from urllib import urlopen
import threading

class Flood(threading.Thread):
    def run(self):
        for i in range(100):
            url = urlopen('http://everet.org/2012/02/how-to-open-sack.html')
            print url.getcode()
q = []
for i in range(50):
    t = Flood()
    t.start()
    q.append(t)
for i in q:
    i.join()

#

{% endcodeblock %}


[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb.png)](http://everet.org/wp-content/uploads/2012/02/image.png)

现在服务器上挂了4个wordpress，也没什么压力。

前几天在原来的服务器上用nginx+webpy写个几个查看信息的页面，webpy就占了60MB的内存，而且发了几百个并发就死了，这让我情何以堪。可能是我的配置有问题，不过内存还是比较无语的问题，所以还是找找更轻量级的实现了。
