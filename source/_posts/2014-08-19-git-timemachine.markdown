---
layout: post
title: "git时光机"
date: 2014-08-19 09:06
comments: true
categories: IT
tags: [Emacs, Git]
---
昨天从Planet Emacsen[^1]发现一个Emacs插件，[git-timemachine](https://github.com/pidu/git-timemachine)，看名字就和苹果的Timemachine一样，也确实是可以像时光机一样浏览文件。

操作非常简单：

<!-- more -->

1. `M-x git-timemachine`进入Timemachine
2. `p`上一个版本
3. `n`下一个版本
4. `w`或者`W`复制当前版本的hash
5. `q`退出。

{% img /imgs/git-timemachine2.gif %}

[^1]: [http://planet.emacsen.org/](http://planet.emacsen.org/)
