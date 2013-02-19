---
layout: page
title: "Linux"
date: 2013-02-08 11:49
comments: true
sharing: true
footer: true
---

## ssh自动发送心跳

{% highlight sh %}
# 打开
sudo vim /etc/ssh/sshd_config
# 添加
ClientAliveInterval 30
ClientAliveCountMax 6
{% endhighlight %}

[rsync](http://roclinux.cn/?p=2643)
