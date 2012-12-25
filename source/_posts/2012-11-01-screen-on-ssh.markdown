---
comments: true
date: 2012-11-01 01:29:12
layout: post
slug: screen-on-ssh
title: screen在ssh远程登录中的使用
wordpress_id: 1425
categories:
- Linux
tags:
- Linux
---

11月了，没想到10月份竟然木有写博客。这几天在迁移服务器，时间不赶，就慢慢弄，顺便记录一下一些技巧。

首先，远程ssh登录到服务器，可能中途会出现网络断掉或者超时，这时候ssh里面就打不了字了，就只能关闭再重新连接。如果我们用vim编辑一个文件到了一半的话，就会蛋疼地多了一个swp。那么如果我们希望在重新连接回去的时候，可以回到之前的工作状态，我们应该怎么办呢？答案是借助screen。

对于screen的使用就不再罗嗦了。具体可以参看后面的参考资料中提供的链接。


## 一些技巧


下面可能会与诸位使用习惯有所冲突，请见谅。


### 把ctrl+a还给我


首先，screen的命令的前缀是ctrl+a，进入screen后，ctrl+a就成了命令前缀了。我经常使用ctrl+a跳到行首，ctrl+e跳到行尾，所以需要修改一下前缀，否则ctrl+a跳到行首这个习惯就得改了。我们在家目录下面创建一个文件**～/.screenrc**。然后在里面写上

{% codeblock bash lang:bash %}
escape ^Zz
{% endcodeblock %}

然后就把前缀改成ctrl+z了，如果需要暂停程序的话，就用ctrl+z z来暂停。这样ctrl+a就回来了。


### 偷懒


每次打screen真麻烦，我们在**～/.bashrc**中加上<!-- more -->

{% codeblock bash lang:bash %}
alias sc='screen'
alias scb='screen -dr normaltask || screen -S normaltask'
{% endcodeblock %}

输入**source ~/.bashrc** 就可以用sc来代替screen了。

为了解决断开连接恢复工作状态的问题，我们假定我们的一个窗口叫normaltask。

然后每次登录的时候，输入 scb，就可以恢复到normaltask这个常用窗口之前的任务了。是不是很方便呢？


### 补全


在screen下面的补全很有问题，和bash有明显的区别，只能补全文件名，对于命令的参数的补全就无法补全了。因为screen默认貌似是使用未登录的shell。

所以，我们在**~/.screenrc**加上一句：

{% codeblock bash lang:bash %}
shell -$SHELL
{% endcodeblock %}

就可以使用bash的补全了。


## 参考资料





	
  1. [screen 教學](http://blog.longwin.com.tw/2005/11/screen_teach/)

	
  2. [screen命令](http://hi.baidu.com/willor/item/3b60db19132035fd65eabfab)

	
  3. [How do I ask screen to behave like a standard bash shell?](http://serverfault.com/questions/126009/how-do-i-ask-screen-to-behave-like-a-standard-bash-shell)



