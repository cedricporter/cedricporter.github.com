---
layout: post
title: "Python MySQLdb默认关闭autocommit带来的坑"
date: 2013-08-20 16:27
comments: true
categories: IT
tags: [Python, mysql]
---

## 问题描述
这篇文章描述我犯的一个很2B的错误。仅此记录一下。

之前写Mini项目的时候，我都是在本机开发的。在昨天上午我把Mini项目放到Paas平台（igor）上，就出现了非常奇葩的bug，就是一个刚注册的用户在登陆后，在刷新页面的时候，有一定概率会在刷新的时候查询不到这个用户。

查了一下log，发现在一些服务器上跑能够查到这个用户，在一些服务器上面运行的时候却查不到这个用户。顿时我就傻逼了，为什么同一条select语句，有的时候查得到数据，有的时候却查询不到数据呢？

<!-- more -->

## 求助场外观众
纠结了一个上午，我决定还是求助导师锴哥，当时我以为是Igor问题。就让锴哥和我一起去找了Paas平台的开发者龙哥。龙哥说不同的wsgi服务器都是连到同一个MySQL服务器的，不可能一下查得到，一下查不到的。龙哥提出可能是autocommit的问题，或者是cursor的问题。

中午回去试了把cursor关闭，然后在查询前重新创建一个新的cursor，还是有同样的问题。抓狂，然后去睡午觉。在睡午觉过程中，突然想到问题的根源是什么。

## 问题根源
之前我在本机开发的时候，只开了一个uwsgi进程，而放到igor上面时，我的程序就会被放到多台服务器上面同时运行。于是这个时候，问题就显露了。

因为mysqldb默认是关闭autocommit的，也就是说，在同一条连接里面，不用显式地begin，就已经是在一个事务里面了。这时候是用commit和rollback或者begin（start transaction）分割两个事务。

假如我们autocommit是关闭的，而且数据库连接是复用的。此时有两个wsgi进程同时开启了，它们都分别建立了连接到数据库，并且都进行了一些基本的select查询。

此时，服务器A一个连接中往数据库中插入了一条记录，然后commit了。此时记录虽然已经在数据库了，但是另一台服务器B此时是看不到这条新纪录的。

为什么呢？因为服务器B没有开启autocommit，导致之前在执行一些select的时候，自己已经自动进入了一个事务，但是悲剧的是，在进入这个事务的时候，数据库还没有这条新纪录。

又因为事务隔离性，所以服务器B那里的连接是看不到这条新记录，所以就出现了我遇到的问题。

## 问题重现
我们打开两个mysql client，首先关闭autocommit。然后分别同时按照从上到下执行，每条语句后面都标上了执行顺序。

``` sql 问题重现
mysql> set autocommit = 0;  #1         │mysql> set autocommit = 0;  #2
Query OK, 0 rows affected (0.00 sec)   │Query OK, 0 rows affected (0.00 sec)
                                       │
mysql> insert into user values ("Stupid│mysql> select * from user;  #4
 ET");   #3                            │Empty set (0.00 sec)
Query OK, 1 row affected (0.03 sec)    │
                                       │mysql>
mysql> commit; #5                      │mysql>
Query OK, 0 rows affected (0.02 sec)   │mysql>
                                       │mysql>
mysql> select * from user where name = │mysql> select * from user where name =
"Stupid ET";  #6                       │ "Stupid ET";  #7
+-----------+                          │Empty set (0.00 sec)
| name      |                          │
+-----------+                          │mysql>
| Stupid ET |                          │
+-----------+                          │
1 row in set (0.00 sec)                │
```

可以看到右边的client里面是查不到新加入的name为"Stupid ET"的用户。

因为在执行#4这条命令的时候，导致右边的client自动进入了一个事务了，而此时数据库是没有的name为"Stupid ET"这个用户的。所以就导致即使数据库里面存在name为"Stupid ET"的记录，右边的client也查不到。

## 感想
出现这个问题的原因是多方面的：

第一，我对事务的理解不够透彻，之前没有在意事务对select的影响。
第二，我没有真正明白autocommit的所蕴含的深意，所以才会出现这种问题。

真是“**问题越奇葩，原因越傻逼**”啊。
