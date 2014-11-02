---
layout: post
title: "shadowsocks的多用户配置"
date: 2014-11-02 12:04
comments: true
categories: IT
tags: [python,shadowsocks]
---

Shadowsocks作为一个开源的番羽土啬工具，还是非常不错的。如果我们在大陆外有自己的服务器，那么可以使用Shadowsocks就可以很方便地获得一个可靠的socks5代理。

一台服务器其实就可以开多个代理用，虽然可以多人使用同一个端口密码，但是感觉这样管理起来并不妥当，例如我想看看谁在使用代理，都无法区分。于是多用户就是必须的了。

咋一看官方文档，好像是没有多用户的配置，仔细看，其实还是可以做到的。

我们可以开多个端口，每个端口使用不一样的密码。我们假如把端口看做用户名，那么就可以有多用户啦！

配置如下：

<!-- more -->

```
{
    "timeout": 600,
    "method": "aes-256-cfb",
    "port_password":
    {
        "40001": "password1",
        "40002": "password2",
        "40003": "password3"
    },
    "_comment":
    {
        "40001": "xiaoming",
        "40002": "lilei",
        "40003": "mike"
    }
}
```

这样，我们可以给每个不同的人，不同的端口和密码，就可以看到区分不同的人了。

然后我们写个[脚本](https://github.com/cedricporter/port-client-ip-monitor)，使用比较简单的方法来加一个监控，每分钟统计一下，看看有谁在使用，然后记个log。

``` bash port-ip-monitor.sh https://github.com/cedricporter/port-client-ip-monitor
#!/bin/bash
#
# File: port-ip-monitor.sh
#
# Created: Wednesday, August 27 2014 by Hua Liang[Stupid ET] <et@everet.org>
#

filename="port-ip-monitor.log"
regex="400[0-2][0-9]"  # monitor 40000-40029

date +"[%Y-%m-%d %H:%M:%S]" >> $filename
netstat -anp | egrep $regex | grep -E "tcp.*ESTABLISHED" | awk '{print $4, $5}' | cut -d: -f2 | sort -u >> $filename
```

修改crontab，加上：
```
* * * * * (cd /var/log/ && /root/projects/port-client-ip-monitor/port-ip-monitor.sh)
```

然后我们在`/var/log/port-ip-monitor.log`便可以看到使用日志了。

如下

```
[2014-11-02 11:04:01]
40001 119.129.165.181
40008 119.129.254.224
40013 219.130.239.3
[2014-11-02 11:05:01]
40001 119.129.165.181
40008 119.129.254.224
40013 219.130.239.3
[2014-11-02 11:06:01]
40001 119.129.165.181
40008 119.129.254.224
40013 219.130.239.3
```
