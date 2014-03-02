---
layout: post
title: "SSH Forwarding导致的垂直越权"
date: 2014-03-02 00:38
comments: true
categories: IT
tags: [Hack, ssh]
---
ssh有个`-A`选项可以启用Agent Forwarding，而Agent Forwarding是一个非常有用的功能。让我们通过跳板机连上另一台服务器的时候，可以省去将私钥拷贝上去、省去我们再次在跳板机中输入passphrase的过程。通过Agent Forwarding，我们在server-1登录到server-2的时候，server-2会将challenge发送到server-1，然后server-1会将它发回到home-pc，然后home-pc的ssh-agent会将解密后的私钥用来验证，然后完成验证。这个链不管有多长，只要路径上一直保持打开Agent Forwarding，随后的级联登陆都不需要输入passphrase。[^1]

我们`man ssh`就会看到下面一段。

<!-- more -->

```
-A   Enables forwarding of the authentication agent connection.  This can also be
     specified on a per-host basis in a configuration file.

     Agent forwarding should be enabled with caution.  Users with the ability to
     bypass file permissions on the remote host (for the agent's UNIX-domain socket) can
     access the local agent through the forwarded connection.  An attacker cannot obtain
     key material from the agent, however they can perform operations on the keys that
     enable them to authenticate using the identities loaded into the agent.
```

使用Agent Forwarding是挺方便的，但是有时候方便的代价就是安全。

我们一般什么时候需要使用Agent Forwarding呢？我觉得在迫不得已的时候再使用它，特别是在大家都有root权限的服务器，就更不应该使用它。正如它的man中的说明一般。

## 可能需要使用Forwarding的场景
#### 我直接在服务器上写代码，需要pull&push代码
有时候，我们可能喜欢直接在服务器上面写代码，然后用`ssh -A`让git服务器从我们本地验证。这样我们就不用将私钥复制到服务器上面了。

#### 线上正式机安装代码的时候需要从版本库clone/pull
正式机安装代码的时候需要从仓库拉去代码，需要验证。用Forwarding就不用在服务器放个私钥了。

#### 我需要从一台服务器rsync到另一台服务器
之前和小口聊的时候，谈到有时需要从一台服务器rsync到另一台服务器。如果我们的私钥可以登录这两台服务器的话，那么用Forwarding的时候就可以直接从一台服务器rsync到另一台服务器了。

#### 需要跳板机才能登陆到某些服务器
有时候有些服务器需要通过跳板机才能登录另一台服务器，所以需要Agent Forwarding。

## 风险
使用SSH Agent Forwarding是有挺大风险的，只要你有root，就可以冒充别人的身份。具体我们可以看[Security Issues With Key Agents](http://www.unixwiz.net/techtips/ssh-agent-forwarding.html#sec)。

我们可以看到agent的socket都放到/tmp下面

``` sh
root@onlinegame:/# ls -l /tmp | grep "ssh-"
drwx------ 2 gz********uan gz********uan      4096  2 28 10:24 ssh-fFesHq2922
drwx------ 2 gu****78      gu****78           4096  2 28 10:15 ssh-mesWFXI787
drwx------ 2 w***i         w***i              4096  2 28 09:49 ssh-MiBNm30073
drwx------ 2 w***i         w***i              4096  2 28 09:44 ssh-PNXoa29541
drwx------ 2 w***i         w***i              4096  2 28 10:31 ssh-SNeGIB3896
drwx------ 2 w***i         w***i              4096  2 28 09:55 ssh-VTkib30511
drwx------ 2 su****a       su****a            4096  2 28 11:19 ssh-XpIKO15823
drwx------ 2 w***i         w***i              4096  2 28 10:02 ssh-ZjubC30883
drwx------ 2 su****a       su****a            4096  2 28 11:19 ssh-zsnXW15762
```

只要有root，通过`SSH_AUTH_SOCK`，就可以冒充任何用了forwarding的人。如下：

``` sh
root@onlinegame:/# export SSH_AUTH_SOCK=/tmp/ssh-VTkib30511/agent.30511
root@onlinegame:/# git clone git@nanny.xxxx.com:w**/sa****.git
root@onlinegame:/# ssh -l *** -p 3xxx0 123.***.***.175
```

<!--
这里仅仅测试了一下，测试可行后就没有继续弄了。请不要XX我啊。
-->

就这样，只要有比我们权限更高的用户forwarding，我们就可以越权访问我们更高权限的东西。

例如我们可以用别人的身份访问自己没有权限访问的版本库的代码，可以冒充别人提交代码留后门，这里想起来一个有人企图在Linux内核代码中留的牛逼的Linux后门[^2]。

或者更严重的，可以越权登录本来没有权限登陆的服务器，登陆后，我们仅仅需要在`~/.ssh/authorized_keys`加上我们的公钥，就可以直接用我们的私钥登录别人帐号了，而且authorized_keys这个也应该也没有人会经常去看，估计留了也很久不会有人发现。或者干脆直接丢一个rootkit[^3]上去，相信大部分Linux服务器都装没有杀软，中上rootkit估计好几年都不会被人发现。

最后，很简单地我们就可以用别人的身份访问自己没有权限访问的版本库的代码，登录自己没有权限登录的服务器。这就导致了垂直越权了。

想起前段时间有童鞋因为将私钥放到服务器上面，被当安全事故通报了。不过感觉Forwarding更加的危险。因为表面Forwarding好像没有东西放到服务器上面，就认为是安全的。其实Forwarding上去可能会导致更危险的情况发生，例如老大Forwarding上去了，于是有root的人就可以变身老大了-_-||。

## 解决
在我们列举完了问题，那对于现有问题，有什么解决方案呢？

#### 我直接在服务器上写代码，需要pull&push代码
对于这种情况，其实也不需要使用Forwarding，我们在本地写好代码，复制上服务器不就好了嘛。

如果不想自己复制，就可以使用让程序自动复制。如下，我们仅仅开始一个自动同步本地文件夹到服务器的脚本，然后就不需要理它了。我们在修改文件的时候，就会自动同步到服务器。

{% img /imgs/mac_20140301_225042_77450LLb.gif %}

好吧，对于测试机，我一直都是这样在自己的电脑写代码，然后自动将项目代码同步到测试机，需要安装代码的时候，再去测试机运行安装脚本。

具体自动同步可以围观《[无缝同步代码到服务器](http://everet.org/2014/03/auto-deploy-to-server.html)》。

#### 线上正式机安装代码的时候需要从版本库clone/pull
对于这种情况，其实也没有必要使用`Agent Forwarding`。

像Github，我们可以使用项目专属的deploy key来放到线上机器进行部署。这个key就算被人黑进服务器，复制走了，最坏的情况就是这个项目的代码被人复制走了，但是如果别人都可以读取到服务器中的key，那必然也可以读取到项目的代码了-_-||。不过Github的deploy key不仅仅是read only，还可以写，这就不太安全了。如果deploy key被人复制走了，就还可以写版本库，这就不太好了。

对于Nanny，熊熊提供了basic auth这种这种方式来读取版本库，可以为专门的项目项目专有的access token。

`git clone http://gzuser:dc6xxxxxxxx5439@nanny.nxxxx.com/gzuser/project.git`

然后我们就可以clone和pull了。这种访问貌似是只读的，所以还是挺不错的。

当然对于用access token clone出来的项目代码，外层文件夹需要将权限改为`700`，这样就只有自己和root能访问。避免随便一个人都可以用`git remote -v`看到我们的access token。这个安全性怎样都比forwarding高。因为能进到文件夹的人，本来就可以看到代码了，看到access token又何妨，反正只是该项目只读，大不了经常改改access token。

#### 我需要从一台服务器rsync到另一台服务器
对于从一台服务器rsync到另一台服务器，其实完全可以配置一下rsync，添加些专门用来复制的用户就好了。

##### rsync服务器的配置

我们在`/etc/rsyncd.conf`中配置一个module。

``` ini /etc/rsyncd.conf
port = 7890

[datafolder]
comment = data rsync between servers
hosts allow = 2.2.2.2 3.3.3.3
path = /tmp/datafolder
uid = vagrant
gid = vagrant
auth users = et_user
secrets file = /etc/rsyncd.secrets
read only = false
list = yes
```

然后增加密码文件`/etc/rsyncd.secrets`

``` ini /etc/rsyncd.secrets
et_user:hellopassword
```

##### rsync客户端

```
rsync -av --delete --port=7890 --password-file=rsync_pass.txt . et_user@remoteserver::datafolder
```

这里，rsync的secret文件权限一定需要600，即仅自己可读取，否则会报错。

这样，我们就创建了et_user这个rsync的用户，两边使用密码来访问。所以即便是rsync也不需要forwarding。

#### 需要跳板机才能登陆到某些服务器
这种情况暂时没有遇到过，暂时没有好的想法，对于安全的跳板机还是可以Forwarding过去的。

不过公用的测试机肯定就不是跳板机了，所以就没有必要`ssh -A`到非常不安全的公共测试机。

## 总结
SSH Agent Forwarding其实只要稍加利用，还是非常危险的一个漏洞，如果骇客黑进了公共测试机，在里面exploit拿到了root权限，而如果大家都Forwarding进到测试机，骇客就可以趁机冒充我们进入到我们能够进入的服务器，那么就会有大片的服务器沦陷了。所以还是请谨慎使用。


[^1]: [http://everet.org/2013/07/ssh-summary.html](http://everet.org/2013/07/ssh-summary.html)

[^2]: [http://www.freebuf.com/news/14021.html](http://www.freebuf.com/news/14021.html)

[^3]: [http://zh.wikipedia.org/wiki/Rootkit](http://zh.wikipedia.org/wiki/Rootkit)
