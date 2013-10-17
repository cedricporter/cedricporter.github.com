---
layout: post
title: "自动为Octopress中的图片增加url前缀"
date: 2013-10-17 19:37
comments: true
categories: IT
tags: [Octopress, Ruby]
---

最近把站点的css和js这些页面包含的静态文件都放到了又拍云的cdn里面，现在决定把图片也一起放到cdn里面。

这样vps就仅仅需要提供博客文章html的给用户下载，其他所有的资源浏览器的可以从就近的cdn获取。可以一定程度上站点的打开速度，而且也可以减少vps的压力（不过都是静态文件，也没啥压力-_-）。

那如何为图片链接加上cdn的前缀呢？一种比较傻的做法是，手工为文章里面的图片链接都加上cdn的前缀，但是这样如果哪天我修改了cdn的地址，那不是又要把所有的图片的前缀都改一遍？这样也太傻了吧。

<!-- more -->

## 动手

于是决定从Octopress下手，在生成文章的时候自动加上前缀，这样日后修改前缀的时候会方便许多。我们可以在`plugins/image_tag.rb`中修改src，在当src是`/`开头的时候，从`_config.yml`中读取前缀，然后加在图片前面。如下代码。[查看Diff](https://github.com/cedricporter/cedricporter.github.com/commit/a0f79a2e6b840c51b68aa89d002f50dc0c4b7ce2)

``` ruby plugins/image_tag.rb
@img['src'] = Jekyll.configuration({})['static_file_prefix'] + @img['src'] if @img['src'][0] == '/'
```

然后在_config.yml里面加上一行：

``` yaml 
static_file_prefix: http://cdn.everet.org
```

这样在生成文章的时候，以`/`开头的图片会自动加上`http://cdn.everet.org`前缀。

我们就可以不用手动为每一张图片加上前缀了，而且在需要修改cdn地址或者不用cdn的时候，就只要在_config.yml里面配置一下前缀，然后重新生成站点就好了。这样非常的方便。

当然这里有一个前提，就是要使用Octopress自定义的`{% raw %}{% img %}{% endraw %}`标签[^1]来插入图片。如下

{% raw %} 
``` html
{% img left /images/hello.jpg Stupid ET #2 %}
```
{% endraw %}

就会生成

``` html
<img class="left" src="http://cdn.everet.org/images/hello.jpg" title="Stupid ET" alt="Stupid ET">
```

## 测试
插入一张今年6月在四川贡嘎转山的照片

{% img /imgs/psb_20131017_211339_11923cq2.jpg %}

[^1]: [http://octopress.org/docs/plugins/image-tag/](http://octopress.org/docs/plugins/image-tag/)
