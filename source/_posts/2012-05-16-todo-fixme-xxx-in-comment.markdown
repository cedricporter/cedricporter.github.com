---
comments: true
date: 2012-05-16 12:58:10
layout: post
slug: todo-fixme-xxx-in-comment
title: 注释中的TODO、FIXME、XXX
wordpress_id: 1094
categories:
- IT
---

第一次见到注释中的TODO是在用VS自动生成MFC框架的时候，里面自动生成的函数可能会有一句注释：


> // TODO Fix this function.


很久以前以为这仅仅是给人看的，原来，它也可以在VS里面开启一个TastList窗口，显示代码中所有的TODO（代办事项）。然后我们就可以方便地在TaskList中看到代码中哪些东西还需要我们完成。这个在其他的开发环境也有类似的功能。

在Python源码中，主要有三个特殊的注释：TODO、FIXME、XXX。


## TODO


说明还有工作需要做，COMMENT简要地描述还有什么工作要做。


> /* TODO: C speedup not implemented for sort_keys */<!-- more -->




## FIXME


说明这里有错误需要修正。


> /* FIXME avoid integer overflow */




## XXX


功能实现了，但是可能需要改进。


> /* XXX -- do all the additional formatting with filename and
lineno here */


使用了这些特殊注释，我们就可以开一个Task的窗口来查看我们项目中的一些任务列表，而且可以方便地定位到代码所在位置。

这可能会比另外拿个文本文件记录要方便得多。
