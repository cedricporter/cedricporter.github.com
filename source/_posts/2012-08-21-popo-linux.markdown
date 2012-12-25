---
comments: true
date: 2012-08-21 13:37:22
layout: post
slug: popo-linux
title: 网易泡泡的Linux虚拟机宿主提示外挂
wordpress_id: 1376
categories:
- Linux
- My Code
tags:
- Linux
- Python
---

在网易实习时，上班一定要开着泡泡，不过泡泡貌似在Linux会严重地水土不服，所以只能装一个虚拟机来解决这个问题。借助[VirtualBox的无缝模式](http://everet.org/2012/07/virtualbox-seamless.html)，我们在一定程度上可以缓解这个问题。但是我平时会在多个虚拟桌面。如果恰巧不幸，我长时间没有切换到泡泡所在的虚拟桌面时，那就会有很长时间都不知道有新的泡泡消息。这个无论对人对己都有非常不好的影响。首先，别人无法在第一时间找到我，即便是我开着泡泡；第二，如果有重要通知，我却不幸地没有在泡泡的虚拟桌面时，那就大祸了。<!-- more -->


## Ubuntu的4个虚拟桌面


[![](http://everet.org/wp-content/uploads/2012/08/2012-08-21-112057的屏幕截图.png)](http://everet.org/wp-content/uploads/2012/08/2012-08-21-112057的屏幕截图.png)

那肿么办呢？

我的想法是，如果虚拟机XP里面的泡泡有收到消息，那么外面的宿主Linux会弹出提示窗口告知我们有新的泡泡消息啦，赶紧冲过去围观吧。

那么具体怎么做呢？

嗯，我的想法是首先在虚拟机XP里面安插一个间谍，如果看到泡泡有新的消息到了，就通知虚拟机外面的Linux说有情报了。那怎么通知呢？我们可以通过HTTP协议来交流吧，这样比较简单，我们在Linux用tornado搭一个服务器，使用pynotify来进行弹窗通知。然后虚拟机XP里面有消息的话，就直接通过HTTP协议通知。好，那我们赶紧开工吧。

[![](http://everet.org/wp-content/uploads/2012/08/tips.png)](http://everet.org/wp-content/uploads/2012/08/tips.png)

啦啦啦啦啦，看上去可以工作。自从用了这个提示外挂，我再也不用每隔一会儿切换到虚拟机所在虚拟桌面去查看了，^_^，变相提高工作效率，减小了上下文切换的开销。

目前我在Ubuntu与XP下使用，其他的还没试过，不过这个应该都是通用的。使用时先编辑一下windowsplugin.py里面的虚拟机宿主的IP，然后将windowsplugin.py放到Windows的启动项，将notify.py放到Linux的启动项即可。

目前的版本是通过轮询监控泡泡的窗口，将来有空的话我会继续开发后续版本。后续版本将会进行DLL Hook，争取可以拿到新消息内容。加油～～


## 依赖包


在Linux宿主需要安装libnotify用户飘窗提示，在Windows需要安装win32gui，其中Win32 Python2.7的win32gui已经附在后面的下载地址里面了。

多谢宇哥，我才发现原来在KDE下pynotify已经换了名字了。

最后，是下载地址啦：[https://github.com/cedricporter/popo-plugin/tags](https://github.com/cedricporter/popo-plugin/tags)。

项目是开源的，有兴趣的同学来一起完善吧～～
