---
comments: true
date: 2012-02-06 17:44:10
layout: post
slug: unix-network-programming-compile-on-ubuntu
title: 《Unix网络编程》的代码在Ubuntu上编译
wordpress_id: 469
categories:
- IT
tags:
- Linux
- Ubuntu
- Web
---

书的示例代码在 [http://pix.cs.olemiss.edu/csci561/prg561.1.html](http://pix.cs.olemiss.edu/csci561/prg561.1.html)

我在Ubuntu 10.10上编译会出现错误如下错误

```
tcpservpoll01.c: In function ‘main’:
tcpservpoll01.c:13: error: ‘OPEN_MAX’ undeclared (first use in this function)
tcpservpoll01.c:13: error: (Each undeclared identifier is reported only once
tcpservpoll01.c:13: error: for each function it appears in.)
tcpservpoll01.c:13: warning: unused variable ‘client’
make: *** [tcpservpoll01.o] Error 1
```
解决方案是去定义一下OPEN_MAX它。

我们在unp.h里面加上


`#define OPEN_MAX 1024`


就好了。

设为1024的原因见 [http://blog.chinaunix.net/space.php?uid=23242876&do=blog&id=2480261](http://blog.chinaunix.net/space.php?uid=23242876&do=blog&id=2480261)
