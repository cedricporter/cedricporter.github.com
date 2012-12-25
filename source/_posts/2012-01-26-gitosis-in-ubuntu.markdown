---
comments: true
date: 2012-01-26 22:27:05
layout: post
slug: gitosis-in-ubuntu
title: Ubuntu使用Gitosis搭建Git服务器，Windows客户端支持中文
wordpress_id: 292
categories:
- IT
tags:
- Git
- Gitosis
- Gitweb
- TortoiseGit
- Ubuntu
---

更详细的教程请见 《Pro Git》[http://progit.org/book/zh/ch4-7.html](http://progit.org/book/zh/ch4-7.html)。


### 安装必备工具


apt-get install git gitweb gitosis

用自己的公钥来初始化Gitosis

root@everet:/var# sudo -H -u git gitosis-init < /tmp/authorized_keys
Initialized empty Git repository in /home/git/repositories/gitosis-admin.git/
Reinitialized existing Git repository in /home/git/repositories/gitosis-admin.git/

对该仓库中的`post-update` 脚本加上可执行权限

root@everet:/home/git/repositories/gitosis-admin.git/hooks# chmod 755 post-update


### 克隆 Gitosis 的控制仓库


$ git clone git@everet.org:gitosis-admin.git

这会得到一个名为 `gitosis-admin` 的工作目录，主要由两部分组成：

<!-- more -->


> Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/everet
$ cd gitosis-admin/

Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/everet/gitosis-admin
$ find .
./gitosis.conf
./keydir
./keydir/cedricporter@ET.pub


如果我们要增加工程：clover，我们可以修改gitosis.conf


> $ cat gitosis.conf
[gitosis]

[group gitosis-admin]
writable = gitosis-admin
members = cedricporter@ET

[group clover]
writable = clover
members = cedricporter@ET


修改完后，提交并推送到服务器。


> $ git commit -am 'add project clover'
[master 3d0dd1b] add project clover
Committer: U-CedricPorter-PC\Cedric Porter <Cedric Porter@CedricPorter-PC.(none)>

$ git push




## Windows客户端


如果我们使用cygwin的git，那么就不会存在任何任何中文乱码问题。

如果我们使用TortoiseGit，我们可以安装一个utf-8的git，下载地址 [http://tmurakam.org/git/](http://tmurakam.org/git/) 。

然后再装TortoiseGit [http://code.google.com/p/tortoisegit/downloads/list](http://code.google.com/p/tortoisegit/downloads/list)，那么它会自动得到git的路径，否则，我们自己去TortoiseGit的设置中设置Git的路径。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb4.png)](http://everet.org/wp-content/uploads/2012/01/image4.png)

此时，除了我们在资源管理器无法直接看到用符号标记的修改的中文文件名的文件，我们只能在右键的”Check for modifications“查看正确的被修的文件，因为在资源管理器中的中文文件名的文件的标记的基本是错误的。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb5.png)](http://everet.org/wp-content/uploads/2012/01/image5.png)
