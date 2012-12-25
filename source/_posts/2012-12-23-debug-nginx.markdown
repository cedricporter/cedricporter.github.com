---
comments: true
date: 2012-12-23 23:41:00
layout: post
slug: '%e8%b0%83%e8%af%95nginx'
title: 调试Nginx
wordpress_id: 1502
categories:
- IT
tags:
- Emacs
- Nginx
---

## 为什么调试Nginx

 

 为什么要调试Nginx，原因多种多样。如果阅读源码的话，开着进程单步走下去不失为一种很好的源码导读方式。 

 

 

## 编译Nginx

    
{% codeblock bash lang:bash %}

  ./configure --prefix="$HOME/my-nginx" --with-debug
  make && make install
  
{% endcodeblock %}
 

  当然还要看一下，生成出来的的Makefile是不是有-O优化，如果有的话需要关闭优化，可以看一下根目录下的Makefile以及objs/Makefile。有的话记得需要改成-O0或者直接删掉就好了。 

    <!-- more -->  

 

 

## 为调试配置Nginx

 

 然后在$HOME/my-nginx/conf下面就是我们的配置文件了，我们编辑nginx.conf，加上：   
{% codeblock nginx lang:nginx %}

  error_log /dev/stdout debug;
  master_process off;
  daemon off;
  
{% endcodeblock %}
   我们可以看到error_log /dev/stdout这样一句，这样可以将输出日志直接打印到标准输出，调试的时候可以实时看到输出。 

    ![file:////home/cedricporter/Pictures/snapshot1-small.png](http://everet.org/wp-content/uploads/2012/12/wpid-snapshot1-small.png)
