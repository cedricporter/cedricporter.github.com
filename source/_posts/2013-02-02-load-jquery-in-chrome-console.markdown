---
layout: post
title: "在Chrome Console中加载jQuery"
date: 2013-02-02 15:35
comments: true
categories: IT
tags: [Chrome, Javascript, jQuery]
---

现在有时候会在console里面玩弄一下某些网站，而某些网站可能没有加载jQuery，所以我们就要自己手动加载。

粘贴到Chrome的Console中。

``` javascript Load jQuery from Console
var jq = document.createElement('script');
jq.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js";
document.getElementsByTagName('head')[0].appendChild(jq);
jQuery.noConflict();
```

<!-- more -->

## 参考
<http://stackoverflow.com/questions/7474354/include-jquery-in-the-javascript-console>
