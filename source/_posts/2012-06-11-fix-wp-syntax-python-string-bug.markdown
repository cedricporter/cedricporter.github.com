---
comments: true
date: 2012-06-11 21:33:17
layout: post
slug: fix-wp-syntax-python-string-bug
title: 修正WP-Syntax高亮Python字符串的bug
wordpress_id: 1164
categories:
- 技术类
tags:
- PHP
- Python
- Wordpress
---

**SyntaxHighlighter Evolved**是wordpress的一个Javascript实现的代码高亮插件，可惜的我的vps网速非常慢，加载一个有代码的页面要等很久才会高亮，这让对读者是非常不友好的，而且不支持rss输出的高亮。于是我想把代码高亮放在服务器这边做好。虽然有人说WP-Syntax会造成服务器压力大，但是如果我们将文章页面都缓存了，那就不存在WP-Syntax高亮时造成的过多的压力。

于是我准备切换到WP-Syntax阵营。不幸的是，我刚刚装上WP-Syntax这个插件，贴上的[ftp.py](http://everet.org/2012/03/ftp-server.html)的Python代码，就发现语法高亮出错了！！

我们可以用简单的代码再现一次这个bug。就是在多行'''注释时会出现这个bug。<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/06/Screenshot-from-2012-06-11-211511.png)](http://everet.org/wp-content/uploads/2012/06/Screenshot-from-2012-06-11-211511.png)

好，那我们现在看看如何解决这个bug。

我发现问题处在**wp-syntax/geshi/geshi/python.php**这个文件里。

问题出在设置Python字符串的标记时漏了'''，我们给他加上就好了。

{% codeblock php lang:php %}
//'QUOTEMARKS' => array('"""', '"', "'"),
'QUOTEMARKS' => array('"""', '"', "'", "'''"),
{% endcodeblock %}

最后效果如下。

[![](http://everet.org/wp-content/uploads/2012/06/Screenshot-from-2012-06-11-211937.png)](http://everet.org/wp-content/uploads/2012/06/Screenshot-from-2012-06-11-211937.png)

最后向WP-Syntax的作者发了邮件，觉得老外真是负责任，很快就回了邮件。

bug的确切地方是出在了插件使用的GESHI高亮库。不过我看了Python.php的最后一次更新是在08年，觉得还是向WP-Syntax作者报告比较靠谱，毕竟用户大都还是使用WP-Syntax而不是直接面向GESHI。
