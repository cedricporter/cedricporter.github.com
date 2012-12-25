---
comments: true
date: 2012-01-31 11:21:43
layout: post
slug: reduce-spam-in-wordpress
title: 减少wordpress垃圾评论的方法
wordpress_id: 437
categories:
- 技术类
tags:
- Web
- Wordpress
---

自从有[http://EverET.org/](http://EverET.org/)开始以来，我的留言板每天都有几十条来自世界各国的垃圾评论，好在装了Akismet，否则我的博客就就被垃圾评论塞满了。这些都是某些RP低的人用机器自动发的，毫无价值，有俄文，波兰文等等乱七八糟的语言。

仔细看看，垃圾评论都集中到留言板。我的留言板的url曾经是 [http://www.everet.org/guestbook](http://www.everet.org/guestbook) ，然后我改成了 [http://www.everet.org/guestbooket](http://www.everet.org/guestbooket) 还是一样，发现原来用 [http://www.everet.org/guestbook](http://www.everet.org/guestbook) 也可以定向到 [http://www.everet.org/guestbooket](http://www.everet.org/guestbooket) ，所以改了等于没改。

于是，我把它改成拼音的，改成 liuyan，果然就没有了垃圾评论。

[http://www.everet.org/liuyana](http://www.everet.org/liuyana)

哈哈。估计垃圾评论的发送器也是用了Google Hack吧。

想起以前在用[NBSI](http://baike.baidu.com/view/535826.html?tp=6_11)注入的时候，也是在里面打开Google页面，然后搜 inurl:asp?= 什么的，然后就让NBSI顺着搜索结果往下测试。

对于垃圾评论发送器我们可以搜索 inurl:guestbook ，然后在搜索结果一部份中就是某些网站的留言板，就可以在那些页面发垃圾评论了。
