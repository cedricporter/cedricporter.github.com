---
comments: true
date: 2012-01-20 13:11:18
layout: post
slug: management-remote-host
title: 管理远程主机的一些技巧分享
wordpress_id: 153
categories:
- IT
tags:
- cygwin
- Linux
- rsync
- ssh
---

对于管理远程主机，我想大家都一般使用ssh吧，在本地是Linux的环境下，那么都是挺方便的，什么都不需要弄就可以用

ssh -l username hostname

来登录远程主机。而在Windows上，虽然有专门的ssh客户端，不过在cygwin里面还是挺亲切的。对于cygwin，我们可以设置在安装的时候选上OpenSSH，这样就可以方便地在Windows上使用ssh了，当然还有很多非常棒的工具可以选择安装，在国内选择163的镜像速度还是挺快的。


### 每次登陆都要密码？免口令SSH登陆！


我们可以创建创建公钥和密钥来实现免口令登陆，公钥放到服务器那里，这样在登陆的时候只要公钥密钥匹配正确就可以不需要输入密码了。

好，现在我们来创建公钥和密钥，我们使用ssh-keygen来生成。


{% codeblock bash lang:bash %}

$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/Cedric Porter/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in id_rsa_test.
Your public key has been saved in id_rsa_test.pub.
The key fingerprint is:
60:7c:f3:42:58:57:42:1f:dc:65:e2:05:3d:49:54:02 Cedric Porter@CedricPorter-PC
The key's randomart image is:
+--[ RSA 2048]----+
|        ..+oEo**B|
|     . o . o.o.B.|
|      = +   . . .|
|     . + o       |
|        S .      |
|         .       |
|                 |
|                 |
|                 |
+-----------------+

{% endcodeblock %}


然后我们就在我们的HOME目录下的.ssh目录下创建了公钥密钥对。<!-- more -->
我们可以看到


{% codeblock bash lang:bash %}


Cedric Porter@CedricPorter-PC ~/.ssh
$ ls
id_rsa  id_rsa.pub  known_hosts


{% endcodeblock %}


其中，id_rsa为我们的密钥，id_rsa.pub为我们的公钥，我们把公钥写到服务器那里的.ssh目录下的authorized_keys里面


{% codeblock bash lang:bash %}

Cedric Porter@CedricPorter-PC ~/.ssh
$ scp ~/.ssh/id_rsa.pub root@everet.org:~/.ssh/authorized_keys

{% endcodeblock %}


然后以后我们的ssh和scp都不需要再输入密码了。


### 每次都要打 ssh -l root everet.org，很烦，使用缩写！


我们可以使用别名，例如，我们可以把 alias et='ssh -l root everet.org' 写入到HOME目录下的.bashrc中，利用别名完成。也可以把登录命令写到一个在环境变量的路径中的一个文件中，例如写到/usr/bin下。


{% codeblock bash lang:bash %}

$ echo "alias et='ssh -l root everet.org'" >> ~/.bashrc
$ # 或者用下面的命令
$ echo "ssh -l root everet.org" > /usr/bin/et
$ chmod +x /usr/bin/et
$
$ # 以后就可以使用et来登录了
Cedric Porter@CedricPorter-PC ~
$ et
Linux localhost.localdomain 2.6.33.4-95.fc13.i686.PAE #1 SMP Thu May 13 05:38:26 UTC 2010 i686 GNU/Linux
Ubuntu 10.10

Welcome to Ubuntu!
 * Documentation:  https://help.ubuntu.com/
Last login: Fri Jan 20 10:55:50 2012 from 123.65.146.220
root@localhost:~#

{% endcodeblock %}



### 断线，丢失之前的工作！？用screen解决ssh的断线重连问题


`# screen -ls`

可以查看现在有的screen，如果找不到命令可以使用apt-get install screen，更详细的说明请见IBM网站的教程

[http://www.ibm.com/developerworks/cn/linux/l-cn-screen/](http://www.ibm.com/developerworks/cn/linux/l-cn-screen/)

一般我们登录后，我们可以使用 screen -S et 来新建一个screen，于是当我们断线后，我们可以重新连接使用 screen -r et 恢复之前的会话。这个很好，当我们需要断开连接去睡觉时，可以让工作继续。所以必要时我们应该使用screen来管理我们的会话。


### 与服务器同步数据


对于同步数据，发现rsync还是相当不错滴。rsync是由Andrew Trigdell和Paul Macherras编写的，其思想与rdist类似，不过侧重点不同。rsync有点儿像加强版的rcp，同步时可以保存权限等信息，还可以增量复制。


#### 下面我们来讨论下在Ubuntu下开启rsync。





	
  1. 我们修改/etc/default/rsync，让它可以在开机自启动。我们将其中的RSYNC_ENABLE=false改为RSYNC_ENABLE=true即可。

	
  2. 设置rsync。配置文件在/etc/rsyncd.conf，如果不存着则创建一个，如创建一个配置文件，vi /etc/rsyncd.conf 。

	
  3. 输入下面内容



``` ini
[et_wordpress]
path = /var/www/et
secrets file = /etc/rsyncd.secrets
read only = false
uid = root
gid = root
```



打完收工！现在重启开启rsync的daemon，输入 /etc/init.d/rsync start 。OK！





#### 现在让我们来在同步数据。


把服务器的数据下载回来，我现在在Windows上，使用cygwin，例如，我把的我的wordpress的文件同步回来，可以使用下述命令：


`rsync -vzrtopg --delete --progress   everet.org::et_wordpress   /cygdrive/h/Coding/everet/et`


当我在本地修改了文件，我可以把我的文件push到服务器上面：


`rsync -vzrtopg --delete --progress  /cygdrive/h/Coding/everet/et/*   everet.org::et_wordpress`


每次都输入那么一长串命令很麻烦吧？我们可以参看上面的第二个标题的使用缩写命令来完成。


`echo "rsync -vzrtopg --delete --progress   everet.org::et_wordpress   /cygdrive/h/Coding/everet/et" > /usr/bin/rcet`
`echo "rsync -vzrtopg --delete --progress /cygdrive/h/Coding/everet/et/* everet.org::et_wordpress" > /usr/bin/rcet2`


然后我们就可以使用 rcet 来下载服务器的数据，用 rcet2 来把本地的数据推送到服务器。

对于我在cygwin下，每次推送到服务器是文件的属主会发生变化，所以我们在推送完后还需要修改属主，这个在cygwin会出现，不知在纯Linux下会不会，不过应该不会滴。如果出现文件属主改变的问题我们可以在推送完后修改下文件属主。


`ssh -l root everet.org "chown www-data:www-data -R /var/www/et"`




#### 好，我们把它加到我们的推送数据的别名缩写中。修改 /usr/bin/rcet2 文件内容为：




`rsync -vzrtopg --delete --progress /cygdrive/h/Coding/everet/et/* everet.org::et_wordpress`
`ssh -l root everet.org "chown www-data:www-data -R /var/www/et"`
`echo "Done."`


我们就可以方便地推送数据了。
