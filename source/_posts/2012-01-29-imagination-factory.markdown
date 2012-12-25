---
comments: true
date: 2012-01-29 02:01:18
layout: post
slug: imagination-factory
title: 我们的图像处理 Imagination Factory
wordpress_id: 342
categories:
- My Code
tags:
- C++
- Imagination Factory
- WPF
- 图像处理
---

Imagination Factory是一款轻巧美观的图像浏览和图像处理软件。这是我们大一时的C++大作业。写下来记录一下以前做了些什么。

我们小组除了俺之外有陈可昕和康磊，两人都是天才少年。陈可昕同学巾帼不让须眉，交给她的几本数千页的WPF英文书籍她都很快就可以消化。康磊同学理科高人，复杂的数学问题他都可以轻松搞定然后去看动漫了，俺有幸可以与此神人同宿舍，只可惜神人已经转专业到了电信。

Imagination Factory的界面采用C#编写，使用了WPF作为界面库。图像处理核心使用C++编写。

项目已经开源，放到 [http://code.google.com/p/imagination-factory/](http://code.google.com/p/imagination-factory/) ，有兴趣的同志们可以接着完善它吧。

Imagination Factory运行时的截图：<!-- more -->

[![QQ截图20120129010840](http://www.everet.org/wp-content/uploads/2012/01/QQ20120129010840_thumb.jpg)](http://www.everet.org/wp-content/uploads/2012/01/QQ20120129010840.jpg)

很久以前我在C++大作业作品展中的PPT上的给的架构图：

<!-- more -->

[![image](http://www.everet.org/wp-content/uploads/2012/01/image_thumb15.png)](http://www.everet.org/wp-content/uploads/2012/01/image15.png)

大致思路：

[![image](http://www.everet.org/wp-content/uploads/2012/01/image_thumb17.png)](http://www.everet.org/wp-content/uploads/2012/01/image17.png)

C++写的动态链接库导出了三个函数，分别用于获取图像，处理图像和保存图像，C#写的界面只是用于处理用户交互。然后把工作交给C++处理。现在看来有点类似MVC，虽然当时也没MVC这个概念，但是都是些很基本的分层的思想。在现在看来以前的设计水平确实挺低下的。


