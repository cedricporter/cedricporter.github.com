---
layout: post
title: "使用Supervisor简化进程管理工作"
date: 2014-11-02 10:26
comments: true
categories: IT
tags: [python, supervisor]
---

这篇东西想写很久了，拖延症晚期患者-.-，今天终于下决心把它写了吧。

很久很久之前，在思考如何部署基于Tornado的服务，就和[郑纪](http://zheng-ji.info/)一起找到了一个Tornado的好伙伴——Supervisor。

Supervisor，简单来说，就是一个Python写的进程管理器。不仅仅可以用来管理进程，还可以用来做开机启动。

我在服务器上面有几个服务：

<!-- more -->

1. 基于Tornado的短链接服务[163.gs](http://163.gs)和很久木有更新的通讯录[5txl.com](http://5txl.com)。
2. node.js的Ghost Blog。
3. 还有 番羽土啬 用的shadowsocks。

需求是，对于这些服务能够做到如下：

1. 重启机器后，能够自启动。
2. 平时有个方便的进程查看方式。
3. 能够有个方便的方式重启进程。

虽然我们自己写启动脚本，但是其实还是挺烦的，特别是，我要开多个同样的服务，就要写几份几乎一样的启动脚本，这个十分之冗余。

庆幸的是，Supervisor[^1]可以解决这些问题，安装好Supervisor，仅需要为Supervisor弄份启动脚本，便可以一劳永逸。

## 安装

非常熟悉的安装方式：`sudo pip install supervisor`，便可以拥有Supervisor，如果没有启动脚本，可以从[这里](https://github.com/cedricporter/supervisor_conf/blob/master/init.d/supervisor)下载一份，放置到`/etc/init.d/`下面便可。

## 配置

我们可以看到启动脚本中，其实默认写了一个启动参数`-c /etc/supervisord.conf`，这里我们可以通过Supervisor附送的贴心的小脚本生成默认的配置文件`echo_supervisord_conf > /etc/supervisord.conf`。

我们可以根据需要修改里面的配置。我这里，每个不同的项目，使用了一个单独的配置的文件，放置在`/etc/supervisor/`下面，于是修改`/etc/supervisord.conf`，加上如下内容：

```
[include]
files = /etc/supervisor/*.conf
```

修改完后，我们便可以将项目的配置文件命名为`.conf`放置在`/etc/supervisor/`下面即可。

这里有个[163.gs](http://163.gs)站点的配置文件163.gs.conf，使用了virtualenv，启动了两个Tornado进程。

``` ini 163.gs.conf https://github.com/cedricporter/supervisor_conf/blob/master/supervisor/163.gs.conf
[program:163gs]
numprocs = 2
numprocs_start = 8850
user = projects
process_name = 163gs-%(process_num)s
directory = /home/projects/163.gs/
command = /home/projects/163.gs/env/bin/python /home/projects/163.gs/main.py --port=%(process_num)s
autorestart = true
redirect_stderr = true
stdout_logfile = /var/log/supervisor/163gs.log
stderr_logfile = /var/log/supervisor/163gs-error.log
```

更多详细的配置可以围观[supervisor官方文档](http://supervisord.org/configuration.html)

## 使用

放置完配置文件后，我们使用`service supervisor restart`启动一下服务（如果是刚刚安装完，那么还没有supervisor进程，如果已经启动了，那么跳过这步）。

当我们需要管理进程的时候，使用supervisor的控制程序连接服务便可以很方便的查看经常状态和管理进程了：

``` bash
@  ~  # supervisorctl
163gs:163gs-8850                 RUNNING   pid 2929, uptime 15 days, 23:35:21
163gs:163gs-8851                 RUNNING   pid 2930, uptime 15 days, 23:35:21
163gs_redis                      RUNNING   pid 2924, uptime 15 days, 23:35:21
5txl:5txl-8070                   RUNNING   pid 2927, uptime 15 days, 23:35:21
5txl:5txl-8071                   RUNNING   pid 2928, uptime 15 days, 23:35:21
ghost                            RUNNING   pid 2923, uptime 15 days, 23:35:21
shadowsocks_me                   RUNNING   pid 2925, uptime 15 days, 23:35:21

supervisor> help

default commands (type help <topic>):
=====================================
add    clear  fg        open  quit    remove  restart   start   stop  update
avail  exit   maintail  pid   reload  reread  shutdown  status  tail  version

supervisor> help reread
reread                  Reload the daemon's configuration files
```

对于使用，直接输入help，就可以看到常用的命令，至于命令是啥意思，可以直接help那个命令，就可以看到解释了。

## 升级Supervisor

升级Supervisor也是非常简单的，使用`pip install --upgrade supervisor`既可以更新程序，然后使用`service supervisor restart`重启一下，就可以升级完成。

我在Github有我的服务器配置[supervisor_conf](https://github.com/cedricporter/supervisor_conf)，有兴趣可以看看。

好，打完收工。

[^1]: http://supervisord.org/
