---
layout: post
title: "From Wordpress to Octopress"
date: 2012-12-25 20:49
comments: true
categories: Life
tags: [Wordpress, Octopress, Git, Ruby, Python]
---

## 为什么
为什么离开Wordpress选择Octopress？ 在Google中搜索Wordpress+Octopress就会找到整版整版的从Wordpress迁移到Octopress的博文，
其中有介绍各种迁移的理由，例如Wordpress太臃肿，Octopress可以让我们像黑客一样写博客。

这些都太高雅了，我只是不喜欢PHP那一坨一坨文明用语一样的代码，这样改起来的时候实在是让人蛋疼。而Octopress是Ruby写的，于是可以借机学习一下*Ruby*（*这个是主要原因*）。

<!-- more -->

## 对于Wordpress的看法
Wordpress可以让我们在浏览器写东西，也可以用客户端来写，例如Windows Live Writer、Emacs + org2blog[^1]。
当我们在其他人电脑，没有客户端的时候，一样可以打开浏览器写。Wordpress既可以是胖客户端，又可以是瘦客户端。
而且Wordpress架构设计灵活，插件主题丰富。用户体验好，也可以用Markdown、org等等其他语言来写。对于静态化，装个WP-Super-Cache插件就可以将所有文章静态化了，而且静态化的程度是可以控制的。

### 缺点
1. 是PHP写的，用MySQL，这两个东西一下就占了一堆内存。对于我们这些穷苦人民的VPS十分不友好。
2. 不联网就没法预览最终效果。


## 对于Octopress的看法
对于Octopress的优点网上也有一堆一堆的评论，我也就不太多说了。我们来看看我觉得的缺点：

### 缺点
1. Octopress是一个胖客户端的博客系统，在写博客前，你需要安装Git、Ruby等等东西，然后把环境调教好，才能开始写东西。
2. 如果去到别人的电脑，或者是Windows的话，那么写个博客都会非常的蛋疼。
3. 相对缺乏插件与主题。
4. 发布一篇文章就要重建整个博客，慢。

### 优点
> Octopress is jekyll with Batteries included.

直接就是用Markdown语法，不用纠结org还是markdown。
可以方便地离线预览文章`rake preview`。

### Misc
Octopress默认的markdown引擎是rdiscount，这个实在是让人难以接受，连footnote都不支持。于是果断换成了kramdown[^2]。kramdown支持footnote，甚至LaTex[^3]。


## 其他

### 写博客的三个阶段
之前看过阮一峰写的一篇文章[github Pages和Jekyll入门](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)，里面有讲到，喜欢写博客的人，会经历三个阶段：

> 第一阶段，刚接触Blog，觉得很新鲜，试着选择一个免费空间来写。
> 第二阶段，发现免费空间限制太多，就自己购买域名和空间，搭建独立博客。
> 第三阶段，觉得独立博客的管理太麻烦，最好在保留控制权的前提下，让别人来管，自己只负责写文章。

好吧，我觉得独立博客的管理确实挺麻烦的，加上刚刚经历买了1年的VPS没到一个月，主机商就跑路的悲剧后，就愈发觉得自己负责可靠性等各种东西的维护确实挺麻烦的。就先暂时放在Github上面，日后再自己管理。

放在Github上面有个坏处是，对于页面都有缓存：`Cache-Control: max-age=86400`，也就是有一整天缓存时间，如果一天内有访问过这个页面的浏览器不刷新的话就直接从cache里面取了。不过应该也没什么大碍，基本不会一天更新好几次。而且除了自己也没什么人访问。

### Emacs
Emacs既可以方便地写Wordpress也可以写Octopress。
![Emacs User At Work](/imgs/emacs-user-at-work.jpg)[^4]

### Ruby
这段时间看了Ruby，发现竟然可以比Python更加优美，我想，日后，可能也会有很多人从Python流向Ruby，就像曾经人们从Perl流向Python一样。

这就是江山代有才人出，长江后浪推前浪啊。事物总是在进步着。

* * * * *

[^1]: <https://github.com/punchagan/org2blog>

[^2]: <http://kramdown.rubyforge.org/index.html>

[^3]: [在Octopress中使用LaTeX](http://yanping.me/cn/blog/2012/03/10/octopress-with-latex/)

[^4]: <http://batsov.com/articles/2011/11/11/blogging-like-a-hacker-evolution/>
