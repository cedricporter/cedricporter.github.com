---
layout: post
title: "无缝同步代码到服务器"
date: 2014-03-01 19:38
comments: true
categories: IT
tags: [Linux, Mac]
---

有时候，用专门的测试机用来测试还是比较方便的，因为上面环境搭好了，而且QA和需求方也可以直接去到测试环境测试。于是就涉及到将代码安装到服务器的这个过程了。

对于代码需要安装在测试机上面，我们有两种方案，一种是直接在服务器写代码，这样写完后，想装的时候就直接运行安装脚本就可以把代码装好了。另一种是在本地写，然后将代码复制到服务器，再安装。

<!-- more -->

## 直接在服务器上写代码
对于直接在服务器上写代码，就挺方便的，不过要注意在服务器开个tmux或者screen，这样在突然断线后或者回家，还是可以恢复到之前的工作的环境。如果没有用tmux之类的，那么如果写代码写到一半给断开连接了，那就悲剧的到时重连的时候还需要恢复编辑文件。

## 在本地写复制到服务器
在本地写代码，我们可以用我们最爱的编辑器[^1]。写完后，觉得好了，就将代码复制到服务器上面，然后去服务器安装代码。这样确实是可以行的，就是每次改点东西，还需要手动复制，就是挺麻烦的。

于是就想自动复制到服务器。那么何时触发复制呢？我觉得在我们修改了，就自动复制就好了。于是我想可以监控文件的变化，如果发生变化，那就调用rsync复制文件。

这里我写了脚本，可以用来监控项目文件夹，如果有变化，就自动复制到远程服务器：

``` bash mac-auto-deploy https://github.com/cedricporter/auto-deploy-by-rsync
#!/bin/sh

local=$1
remote=$2

cd "$local" &&
fswatch . "date +%H:%M:%S && rsync -aztH --exclude '#*' --exclude .git --exclude .svn --progress --rsh='ssh -p32200' . $remote"
```

所有的代码都在[https://github.com/cedricporter/auto-deploy-by-rsync](https://github.com/cedricporter/auto-deploy-by-rsync)。需要的同学可以clone下来试试。

### 使用
例如我们在Mac上面，可以在项目的文件夹根目录运行下面的命令。

```
@ ~/git/vipbar-b2c % mac-auto-deploy . gzhualiang@dev35:~/git/`basename $(PWD)`
```

在上述例子中，mac-auto-deploy会自动检查文件修改，如果修改了就会使用rsync将当前文件夹同步到dev35这台服务器的`~/git/vipbar-b2c`目录中。只要在一开始打开就不用理他了，就只管写代码就好了，觉得需要安装的时候，就在服务器的shell运行一下安装脚本，项目就可以安装好了，就不再需要关注代码的复制了，就像在服务器写代码一样了。

## Screencast[^2]

{% img /imgs/mac_20140301_225042_77450LLb.gif %}

[^1]: 当然在服务器也可以用vim/emacs，不过像我配置的emacs会依赖许多外部程序，公共的测试服务器又不能随便装东西，在受限的服务器用阉割的Emacs还是挺不爽的，所以还是在本地用配好的环境开发是最舒服的。

[^2]: gif视频，是用Mac自带的QuickTime Player录的，然后用[mov2gif](https://github.com/cedricporter/mov2gif)将mov装换成gif。
