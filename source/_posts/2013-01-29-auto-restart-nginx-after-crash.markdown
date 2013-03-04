---
layout: post
title: "自动监控Nginx进程"
date: 2013-01-29 22:51
comments: true
categories: IT
tags: [Nginx]
---
今天在长途车上，收到邮件说服务器挂了，马上手机登上去。发现nginx进程全部死掉了。

看了半个小时的日志，nginx和dmesg的都没有任何有意义的信息。不过估计又是out of memory，因为最近我把php-fpm的max_children从3调到了4。不过也很纳闷为啥每次nginx挂掉都没有任何日志留下。OpenVZ的vps真是蛋疼。

<!-- more -->

唉，先不理它了，加上进程监控是关键。

比较懒，直接借助cron。

修改`/etc/crontab`，加上下面一行

`* * * * * root ps -C nginx > /dev/null 2>&1 || (nginx -t && service nginx restart)`

每分钟检查一次nginx进程还有没有，没有就重启它。

好，最后运行`service cron restart`让crontab生效。
