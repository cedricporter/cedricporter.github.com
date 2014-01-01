---
layout: post
title: "让Octpress文章里面的链接打开方式为新tab打开"
date: 2014-01-01 20:19
comments: true
categories: IT
tags: [Octopress, Javascript]
---

本来在Octopress使用的链接是用markdown方式插入的链接`[EverET.org](http://EverET.org)`，这样在看文章的时候点击link就会直接跳转到url那里了，我不想有这样的体验，所以决定给文章里面的url加上`target="_blank"`，让用户点击的时候在新窗口打开链接。

这个在哪个做比较好呢？想了一会还是在前端做比较好。非常简单，在`source/_includes/custom/head.html`加上对[http://everet.org/javascripts/link-target-blank.js](http://everet.org/javascripts/link-target-blank.js)，这个文件的引用即可：

`<script src="/javascripts/link-target-blank.js" type="text/javascript"></script>`

内容：

``` javascript
// Author: Hua Liang[Stupid ET]

$(function () {
    $("div.entry-content a[href^=http]").attr("target", "_blank");
});
```

就是将文章下面的`a`标签中以http开头的链接加上`target="_blank"`。

为什么要判断以http开头呢？因为文章里面的链接还有脚注和目录的链接，这些链接其实不需要修改的。

Done!

