---
layout: page
title: "Git"
date: 2013-02-08 11:45
comments: true
sharing: true
footer: true
---

## git 恢复单个文件
如果你只是要恢复一个文件(修复未提交文件中的错误),如”hello.rb”, 你就要使用 git checkout

{% highlight console %}
$ git checkout -- hello.rb
{% endhighlight %}

