---
comments: true
date: 2012-01-31 19:33:29
layout: post
slug: access-svn-with-git
title: 使用Git访问SVN
wordpress_id: 441
categories:
- IT
tags:
- Git
- SVN
---

想必大家都使用过Subversion吧，也想必大家都对SVN这种脱离了网络和服务器就寸步难行的工作方式嗤之以鼻吧。使用SVN我们看个log首要联网。

 

在服务器在因特网的情况下，网速让使用SVN变成一件十分蛋疼的事情。因为SVN事事都要联网，没有网络就无法工作，这个是集中式版本控制器十分大的缺陷。

 

好在后来Linus在BitMover在收回开源社区的BitKeeper这款分布式版本控制器的授权后，开发了Git。这款Linus又一力作又再次改变了世界。

 

Git有个很好的功能就是可以访问SVN服务器。这点也让我们这些SVN的使用者也稍稍改善了SVN的用户体验。

 

Git可以将版本先提交（commit）到本地的分支，到时机成熟之时再一次推送（push）到远程服务器。而且查看历史也不需要联网了，因为Git默认会把整个SVN版本库都克隆下来。

 

像我们使用Google Code来托管我们的开源代码时，我们可以在上面创建SVN的版本库，Git版本库貌似访问不了，没办法。

 

Google Code对一个项目有4GB的空间，有wiki等等，还可以上传文件供用户下载，这个非常的好。

 

例如，我的vim和emacs的配置我放到了 [http://code.google.com/p/et-vim-setting/](http://code.google.com/p/et-vim-setting/)

 

 

我们可以使用如下命令克隆我们的Google Code上的项目。

 

`git svn clone --username cedricporter@gmail.com -s https://et-vim-setting.googlecode.com/svn vim_setting`

<!-- more -->

 

我在用如下命令把我的Windows上的配置文件_vimrc提交到Google Code的SVN服务器上。

 
``` console
Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/vim_setting       
$ git status         
# On branch master        
nothing to commit (working directory clean)

Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/vim_setting       
$ git add .

Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/vim_setting       
$ git status        
# On branch master        
# Changes to be committed:        
# (use "git reset HEAD <file>..." to unstage)        
#        
# new file: _vimrc        
#

Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/vim_setting       
$ git commit -am 'add windows setting'         
[master 6d6f696] add windows setting        
1 files changed, 632 insertions(+), 0 deletions(-)        
create mode 100755 _vimrc

Cedric Porter@CedricPorter-PC /cygdrive/h/Coding/vim_setting       
$ git svn dcommit        
Committing to https://et-vim-setting.googlecode.com/svn/trunk ...        
Authentication realm: <https://et-vim-setting.googlecode.com:443> Google Code Subversion Repository        
Password for 'Cedric Porter':        
```

 

更多的Git教程请查看《Pro Git》，在美国的Amazon有卖，电子版地址 [http://progit.org/book/zh/](http://progit.org/book/zh/) ，他们的翻译也是使用Git管理。
