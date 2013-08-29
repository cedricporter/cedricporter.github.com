---
layout: post
title: "SSH总结"
date: 2013-07-29 22:25
comments: true
categories: IT
tags: [Linux, ssh]
---

## 引言
虽然使用ssh的时间也不短了，但是其中花去思考的时间并不多。以至于那么长时间过去了，我对ssh的认识也没有什么提高，真是自惭形秽啊。

在以前，我的私钥是没有用passphrase加密的，如果私钥被盗了，那我的github和vps就彻底沦陷了。

今天做的任务是学习ssh，加上导师兼师兄锴哥也增加了一些ssh方面的题目，于是我也不得不花时间努力学习一下ssh。这个过程中，我发现我以前没有加密私钥的做法是非常不妥的。于是就决定重新配置我的公私钥。

<!-- more -->

因为现在已经到公司上班了，所以我需要两套公私钥。一套用于私人项目，另一套用于公司的项目。省得哪个被盗了影响了另一个。

## ssh生成公私钥

我们通过如下命令生成id_rsa_home[.pub]和id_rsa_work[.pub]两套公私钥。

``` sh
ssh-keygen -t rsa -C "cedricporter@home" -f ~/.ssh/id_rsa_home
ssh-keygen -t rsa -C "cedricporter@work" -f ~/.ssh/id_rsa_work
```

然后我们需要将私钥加入到ssh-agent中。这个我们在每次开机的时候都需要输入passphrase将私钥解密。

``` sh
ssh-add ~/.ssh/id_rsa_home
ssh-add ~/.ssh/id_rsa_work
```

## 复制公钥到服务器

``` sh
ssh-copy-id -i id_rsa_home root@everet.org
# 如果端口不是默认端口
ssh-copy-id '-p 9999 root@everet.org'
# 等价于下面的命令
ssh -l root -p 9999 everet.org 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa_home.pub
```


## ssh原理

对于ssh原理，阮一峰有很好的讲解，我也就不重复废话了：

1. [SSH原理与运用（一）：远程登录](http://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html)
1. [SSH原理与运用（二）：远程操作与端口转发](http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html)
1. [数字签名是什么？](http://www.ruanyifeng.com/blog/2011/08/what_is_a_digital_signature.html)

## Agent Forwarding

我们来看这么一个场景：假如我们有三台计算机：home-pc、server-1和server-2。我们从home-pc通过ssh登录到server-1，然后，我们需要从server-1登录到server-2。如果我们想在从server-1登录到server-2，那我们可以怎么办呢？

1. 在从server-1登录到server-2的过程中，输入密码。
1. 我们可以通过在server-1下面放一个server-2配对的私钥，然后就不用输入密码。

这个是我以前的做法，我直接在server-1下面创建了一对公私钥，然后把公钥复制到server-2，然后在server-1登陆server-2就不用输入密码了。不过这样如果私钥有用passphrase加密的话，那还是需要输入密码。

但在看了[An Illustrated Guide to SSH Agent Forwarding](http://www.unixwiz.net/techtips/ssh-agent-forwarding.html)这篇文章后，我发现我真是一个SB。原来使用Agent Forwarding可以非常好地解决这个问题。

Agent Forwarding是一个非常有用的功能。让我们通过跳板机连上另一台服务器的时候，可以省去我们再次在跳板机中输入passphrase的过程。通过Agent Forwarding，我们在server-1登录到server-2的时候，server-2会将challenge发送到server-1，然后server-1会将它发回到home-pc，然后home-pc的ssh-agent会将解密后的私钥用来验证，然后完成验证。这个链不管有多长，只要路径上一直保持打开Agent Forwarding，随后的级联登陆都不需要输入passphrase。

我们可以通过加上“-A”这个参数来启用Agent Forwarding，不过这个有一定的安全风险。就是ssh-agent所用的unix socket是放在/tmp目录下面的，只要有root权限就可以冒充你登陆。总结，使用Agent Forwarding的好处在于，中间的跳板机不需要有任何私钥也可以让登陆免密码输入。坏处在跳板机的上面，root权限的用户可以通过agent创建的unix socket登陆。

``` sh
ssh -A root@everet.org
```

## SSH创建代理
一句话创建sock5代理，在本地运行：

``` sh
ssh -qfnNT -D 127.0.0.1:3389 -l root -p 9999 ipv6.everet.org
```

然后就在本地打开了一端口为3389的sock5代理。这条命令我在华工那坑爹的校园网的时候经常使用，因为校园网ipv4不能访问国外的网站，不过ipv6可以访问，好在我有台支持ipv6的vps，然后就拿来做代理来连接国外网站，真是蛋疼。

## 总结
学无止境，即便是我们熟悉的东西，还是有我们不熟悉的一面。
