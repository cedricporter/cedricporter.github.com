---
comments: true
date: 2012-04-23 01:26:45
layout: post
slug: ubuntu-screenshot
title: Ubuntu上的屏幕截图
wordpress_id: 930
categories:
- IT
tags:
- Linux
- Ubuntu
---

偶们都是被QQ截图宠坏的一代，QQ截图确实很好用，不过在Linux下就木有了，于是该怎么办呢。

我们可以使用系统自带的截图，默认按Print Screen全屏截图或者Alt + Print Screen截活动窗口。

那如果我们想截一个区域，就要打开screenshot，然后选中Select area to grab，非常地麻烦。

<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-011846.png)](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-011846.png)

好，现在我们来添加快捷键Ctrl+Alt+A来模拟QQ截图。我们在系统设置中的键盘设置中打开快捷键。添加一个自定义快捷键。

[![](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-012037.png)](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-012037.png)

Command填上：gnome-screenshot -a ，也就是区域截图模式。

[![](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-012047.png)](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-23-012047.png)

搞定。
