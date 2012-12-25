---
comments: true
date: 2012-02-28 01:00:13
layout: post
slug: what-bugzilla-is-down
title: What？Bugzilla is down
wordpress_id: 623
categories:
- 技术类
tags:
- Bugzilla
---

Bugzilla是基于Web的通用软件缺陷追踪工具。目前Linux Kernel，Apache，Mozilla，Gnome，KDE，Open Office，Eclipse，Facebook，Nokia，Yahoo! 等等都采用了Bugzilla这个缺陷追踪工具。

 

这段时间写代码我们的bug list都是写在一个txt里面，真是弱爆了……于是想用有效的工具来管理我们的bug。

 

据说在微软，大家上班第一件事就是打开缺陷追踪工具看看昨天测试人员找出了什么bug，然后开始一天的工作。

 

确实，只有有效的设计、实现、测试和管理才能保证软件的质量。否则我们的软件都是不堪一击的。

 

于是偶装了bugzilla来管理我们的一些项目。

 

在偶改完设置后，Bugzilla就显示“Bugzilla is down”，然后偶就很无语，发现在首页登录都登录不进去了，这要我如何是好。

 

Google了下，发现访问 [http://bug.everet.org/editparams.cgi](http://bug.everet.org/editparams.cgi) 就可以进去修改去设置了。后来发现是我在shutdownhtml的框里填了东西，他就down了。清空它的值就好了。

 

这真是弱爆了的用户体验啊。不过也怪我没仔细看说明。

 

>   
> 
> #### shutdownhtml 
> 
>       If this field is non-empty, then Bugzilla will be completely disabled and this text will be displayed instead of all the Bugzilla pages.
