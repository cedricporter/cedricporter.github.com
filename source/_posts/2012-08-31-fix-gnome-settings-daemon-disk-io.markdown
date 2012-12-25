---
comments: true
date: 2012-08-31 10:51:34
layout: post
slug: fix-gnome-settings-daemon-disk-io
title: 解决Ubuntu下gnome-settings-daemon高磁盘IO的问题
wordpress_id: 1395
categories:
- Linux
tags:
- Linux
- Ubuntu
---

最近在用Ubuntu的时候，总是发现用着用着整台电脑就卡死了，什么都动不了，然后硬盘灯一直处于常亮状态。几次艰难地打开shell，发现都是gnome-settings-daemon一直在读写硬盘。这个究竟是什么问题呢？

strace一下，看看，这个进程在干啥。

{% codeblock console lang:console %}
cedricporter@cedricporter-Lenovo:~/projects/CaptchaSystem$ sudo strace -p 2207
[sudo] password for cedricporter: 
Process 2207 attached - interrupt to quit
lstat("/home/cedricporter/.thumbnails/normal/b6c1d4f6fff0b536652c83081e5233e1.png", {st_mode=S_IFREG|0600, st_size=5398, ...}) = 0
lstat("/home/cedricporter/.thumbnails/normal/739ea0e4eabe22c5b551156fc3ff93da.png", {st_mode=S_IFREG|0600, st_size=6059, ...}) = 0
lstat("/home/cedricporter/.thumbnails/normal/2aac704bfd3d3a865f66e5c3ee2ba80a.png", {st_mode=S_IFREG|0600, st_size=6362, ...}) = 0
lstat("/home/cedricporter/.thumbnails/normal/5dbe53248aa8a41612137100a315e076.png", {st_mode=S_IFREG|0600, st_size=6260, ...}) = 0
{% endcodeblock %}

出来的结果就像刷屏一样，全部都是lstat的系统调用，读取的都是.thumbnails下面的图片。<!-- more -->

突然想起这段时间我都在做验证码，在硬盘里面生成了不计其数的验证码图片。去gnome的网站上转了一下，发现原来很多人都遇到这个问题，特别是搞摄影或者经常处理图片的人。

原来gnome-settings-daemon会经常检查缓存是否过期，是否需要删除或者更新，然后就会读一遍缓存中的图片。这个真是悲剧啊。

于是我在非常卡的情况下，把.thumbnail目录删了，瞬间就不卡了。


## Solution


既然这样，我也就不让它检查缓存了，到时塞爆硬盘我再手动删除缓存算了，不想经常电脑因为硬盘卡住完全动不了。

我们打开gconf-editor，设置下面两个值为-1.
/desktop/gnome/thumbnail_cache/maximum_age
/desktop/gnome/thumbnail_cache/maximum_size

然后就不会自动更新缓存了。 当然也可将这两个值设置小一点，就不会有那么多缓存要扫描了。


