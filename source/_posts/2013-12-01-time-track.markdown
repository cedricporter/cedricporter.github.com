---
layout: post
title: "追踪时间"
date: 2013-12-01 22:54
comments: true
categories: Life 
tags: [Asana, Toggl]
---
在正正一个月前，11月1日，在和龙哥聊天的时候了解到龙哥他每天都在记录时间，用的是自己写的一个工具[Woodpecker](https://github.com/gombiuda/woodpecker)，于是晚上回去我又再次去了龙哥github上面的一个项目Woodpecker那里围观，也想开始试用。在readme那里有讲到一本书[《奇特的一生》](http://book.douban.com/subject/1115353/)。在和龙哥聊的过程中，龙哥也非常推荐这本书，于是我就去看了电子版（这本书前两周刚刚再版了），觉得非常不错。讲的是俄国的一个科学家柳比歇夫的使用了56年时间记录法。

## Asana

<!-- more -->

龙哥的Woodpecker是基于[Asana](https://asana.com/‎)的时间记录工具，可以记录Asana上面的任务的时间。当时我去看了一下Asana，觉得完全不知道怎么用，很复杂，就没理它了。过了几天，在龙哥的影响下，我下定决心还是认真看看Asana。首先去官网看了使用视频，就基本对它的整体使用有了一定的认识，而且Asana也有丰富的快捷键支持，这个还是非常不错的。以前用过一些任务管理的工具，要不然太简单，要不然就是做得一般又要收费，就没有使用了。觉得Asana做的比其他的都好很多很多，而且现在还没见到收费。Asana是由Facebook的联合创始人达斯汀·莫斯科维茨（Dustin Moskovitz） 以及Facebook的前工程师贾斯汀·罗森斯坦（Justin Rosenstein）创办的。

现在基本我有所有的任务管理都在Asana上面了，完全兼容GTD，而且子任务可以无限层次，任务可以一直划分下去，体验除了网速问题外，其他都非常的棒。而且可以同步到Google Calendar，满足了我所有的需求，可以认为是一个终极的任务管理工具。而且还可以团队协作，觉得完全可以代替redmine。

## Toggl

对于时间记录，Asana上内置支持了Harvest，不过Harvest是收费的，而且感觉非常难用。龙哥的Woodpecker基于Asana，貌似主要是记录Asana任务的时间，而我每天做的挺多事情都不是我所计划的，也没有出现在Asana里面。所以还是使用简单的[Toggl](https://www.toggl.com/)来记录时间。

对于联合Asana和Toggl，有个Chrome插件可以做到，就是官方的Toggl-Button，不过原版的Toggl-Button不太智能，我就Fork了一个[Toggl-Button](https://github.com/cedricporter/toggl-button)出来根据自己的需求修改（安装的话，可以下载到本地，然后在Chrome的插件管理那里把这个插件加上），可以根据Asana的项目名自动选择Toggl的项目名，而且会自动在Toggl那里加上一个tag，记录asana的task id，这样就可以在统计数据的时候关联Asana和Toggl了，就可以统计Asana的一个任务的时间了，不过这个当然有局限，就是要用Chrome才可以。

{% img /imgs/snapshot5_20131201_233003_35094Tw.png %}

如图中的红色按钮，就是Toggl-Button啦，按一下，Toggl那边就开始计时了。

## hua.bz

Asana和Toggl都有丰富的API，这样非常方便扩展。鉴于Toggl的数据图表做得非常的烂，所以还是决定根据Toggl的数据来进行绘图。

{% img /imgs/snapshot4_20131202_000249_3509Fe2.png %}

直接访问[hua.bz](http://hua.bz)就可以看到过去7天我的每种类别的时间分布，画图用的是龙哥推荐的[d3js](https://github.com/mbostock/d3)，其中绘图代码一部分参考了龙哥的[Woodpecker](https://github.com/gombiuda/woodpecker)，数据直接使用Toggl Report API。

原来的页面会现在我这几天做的所有的事情，不过去掉了，省得在直播我的生活-_-

[hua.bz](http://hua.bz)的后台代码都在我的github的[toggl-graph](https://github.com/cedricporter/toggl-graph)里面，不过代码很乱，以后有空再慢慢整理。

## 每周总结

现在决定还是还是需要每周总结，有了时间的数据，就需要分析，总结，这样才能改进。21天能够养成习惯，已经21天了，相信时间记录的习惯也已经养成了。

把总结写在了[i.hua.bz](http://i.hua.bz)。






