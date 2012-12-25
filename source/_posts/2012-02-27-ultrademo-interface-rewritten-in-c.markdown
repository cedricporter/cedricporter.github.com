---
comments: true
date: 2012-02-27 15:07:15
layout: post
slug: ultrademo-interface-rewritten-in-c
title: UltraDemo的界面用C#重写
wordpress_id: 610
categories:
- My Code
tags:
- C++
- UltraDemo
---

UltraDemo是一款数据结构的实践与演示的平台，可以在上面编写类C的代码。

通过UltraDemo，我们将可以以图形化的信息观察到我们写的数据结构的变化的过程。

UltraDemo是由编译器、汇编解释器和动画框架加上动画组成的平台。可以单步调试，查看内存变量等之外还可以观看动画形式的数据结构，这样可以方便初学者更快地理解各种数据结构。

原来的界面是C++/MFC写的，长得和VS2008差不多，看上去风格挺古老的。

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb14.png)](http://everet.org/wp-content/uploads/2012/02/image14.png)

<!-- more -->

现在正在由屠文翔同学使用C#/WPF重写界面，现在正在进行中，将来会有更佳的用户体验。

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb15.png)](http://everet.org/wp-content/uploads/2012/02/image15.png)

目前编译器还比较废，等做完折纸再接着完善了，说到底现在只有3个苦命的娃有开发，其他人都是在打酱油唉。所以俺们还是相当的苦逼的。

UltraDemo是一年前我们组做的数据结构大作业，相对于其他的数据结构演示软件新颖之处就是，我们可以在上面自己写代码，并且看到运行过程中的各种细节。


### 工作原理


基本工作原理是将代码翻译成汇编代码，然后一个汇编解释器解释汇编来运行程序。

动画模块则监视着特殊命名的变量来演示。

其中动画是以dll插件加载，任何人只要遵循我们的接口都可以为UltraDemo这个平台增加数据结构的动画。


### 进度


最近我们主要人员比较忙，还有两个全新的东西要做，需要花费很多精力才可以完成。于是我们决定将UltraDemo先放一下，等到临近软件文化节再开工写动画了。
