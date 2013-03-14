---
layout: post
title: "Git-svn历险记"
date: 2013-03-11 15:54
comments: true
categories: IT
tags: [SVN, Git]
---

## 引言

这段时间因为作业原因又用回了Google Code的svn服务，瞬间感觉又倒退了很多年。

想起以前使用Google Code的svn服务，每次提交，查看log都要等上几分钟，都几乎没了Commit的兴致了。以前，我只是怪罪于学校的网络环境实在太恶劣了。

后来，直到我遇上了Git，才发现，这不仅仅是网络的问题，svn的这种集中式的版本控制在广域网本身就是一种缺陷。

<!-- more -->

Git是一款分布式的版本控制器，每个人的电脑中都存在完整的版本库，即使中央版本库废掉了，一样可以用任意一个版本库进行恢复。不过最吸引的人是Git的离线Commit，也就是你没有网络的时候也可以提交，当需要的时候再push到服务器上。当然，这得要求Git拥有一套非常好的分支合并方案，不过这个便是Git的强项。

## git-svn

svn因为各种原因，还得以存活在世界上。不过非常感谢git-svn，我们可以使用git来操纵svn版本库，这是不是很酷呢！

通过git-svn，我们可以离线commit，本地轻量级的branch（不过无法记入svn版本库）等等。

## clone

svn版本库的结构一般分为3个文件夹trunk、branches、tags。顾名思义，trunk是主干，一般稳定的可发布部分存放于此，而branches存放分支文件夹，tags同分支。

我们来用svnadmin创建一个版本库，然后初始化目录结构，最后用git-svn clone svn的版本库：

``` console
$ svnadmin create demo
$ svn co file:///home/cedricporter/projects/test_svn/demo/ svndemo
Checked out revision 0.
$ ls
demo  svndemo
$ cd svndemo/
$ mkdir trunk braches tags
$ svn add *
A         braches
A         tags
A         trunk
$ svn ci -m "initialized directory structure."
Adding         braches
Adding         tags
Adding         trunk

Committed revision 1.
$ ls
braches  tags  trunk
$ cd ..
$ ls
demo  svndemo
$ git svn clone -s file:///home/cedricporter/projects/test_svn/demo/ gitdemo
Initialized empty Git repository in /home/cedricporter/projects/test_svn/gitdemo/.git/
r1 = 06911f31d2f5031c71dd26c2acd1f239dacac93f (refs/remotes/trunk)
Checked out HEAD:
  file:///home/cedricporter/projects/test_svn/demo/trunk r1
```

其中`git svn clone -s`中的`-s`是`--stdlayout`的缩写，是表示clone的svn版本库是拥有标准结构的svn。这样Git在Clone完后会自动检出trunk。

## update

对于`svn update`，对应的命令是`git svn rebase`。这里将svn服务器的数据拉取下来，并且尝试自动合并。所以会有可能导致冲突。

## commit

对于commit，可以直接使用`git commit`来commit到本地的git版本库中。

在觉得时机合适的时候，可以用`git svn dcommit`，将本地的commits一次性推送到svn服务器。

如果不确定现在dcommit到哪里去，可以加上`-n`（同`--dry-run`），即`git svn dcommit -n`看看会推送到那个分支，这个取决于log中的git-svn-id。

## branch

在Git中可以使用`git branch [branch_name]`轻松创建分支，不过这种仅仅是git的本地分支，无法推送到svn服务器上。不过我们可以使用svn的分支。

如果我们需要创建svn分支，可以通过`git svn branch [branch_name]`创建svn分支。这里实际上执行的是`svn cp xx xxx`。一般情况下，是会将服务器中的trunk目录拷贝到branches目录下面。不过这取决于log中的git-svn-id。

我们在创建完svn分支后，可以本地的对应git分支，并且检出。

``` sh
git checkout -b local/[branch_name] remotes/[branch_name]
```

这里会创建一个叫做"local/[branch_name]"的分支，为什么加上`local/`前缀呢，这个主要是为了方便区分本地和远程分支。要不然Git会抱怨ambiguous。

然后我们就可以在这个分支正常开发提交和推送了。

## merge

当我们在分支里完成必要工作后，就需要分支合并到master(trunk)中。

这里切记在Merge的时候加上`--no-ff`，即不要fast-forward，而在merge之后需要创建一个commit，这样master的git-svn-id才会正确，否则我们合并之后在master中进行dcommit的时候会推送到branches目录里面去了。

``` sh
git checkout master
git merge local/[branch_name] --no-ff
git svn dcommit -n # 看看会push到哪里
git svn dcommit
```

如果merge的时候忘了加上--no-ff，那就悲剧了，你需要用`git reset`将master游标重置回合并前的那个节点。然后再重新merge。

merge完记得最好删除本地的git分支[^1]。


## tag

打tag也很容易，用`git svn tag [tag_name]`就可以了。其实这个是`git svn branch -t [tag_name]`的alias。也就是将trunk复制一份放到tags目录。不过也要注意git-svn-id是否正确。以免发生错误复制。

## 完结

在平时可以使用Git来连接老就的svn版本库，这不失为一种过渡的办法。需要更多的学习Git可以围观[《Git权威指南》](http://book.douban.com/subject/6526452/)，以及[《Pro Git》](http://git-scm.com/book/zh/)。

## Footnotes

[^1]: [Git-与其他系统-Git-与-Subversion#切换当前分支](http://git-scm.com/book/zh/Git-%E4%B8%8E%E5%85%B6%E4%BB%96%E7%B3%BB%E7%BB%9F-Git-%E4%B8%8E-Subversion#切换当前分支)
