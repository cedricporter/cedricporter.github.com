---
layout: post
title: "From Linux to Mac OS"
date: 2014-02-03 16:10
comments: true
categories: IT
tags: [Linux, Mac]
---

年前终于买了台新电脑，原来的联想Y550也用了4年半了，虽然换了ssd[^7]，不过CPU还是有很大的瓶颈，Core P7350 2.0GHz，不知是不是CPU老化了，跑个浏览器都有些卡，虚拟机直接就没法跑了。而且电池之前换过新的，新的也只能用个1个小时，加上15.6寸又大又笨重，背出去十分辛苦，所以就咬咬牙，换了台便携一点的笔记本。这样去哪里都可以背上电脑。

本来想入手Thinkpad装Linux的，因为非常kde用起来非常方便，可定制也非常强，不过看到Thinkpad的性价比还差过Macbook，就决定入手13 rmbp了。就算mac os不好用也可以装一个linux。

<!-- more -->

拿到rmbp后，一直在惊叹屏幕的的惊艳，看东西十分锐利，可视角和色彩也非常满意。

刚开始用Mac OS有很多东西都是不习惯，不过很快就适应了。

我把Emacs，zsh的配置[^1]拷过去基本上就可以直接使用了，而且高分屏看上去字体非常清晰。常用的软件用brew安装一下，就都回来了。Chrome和Firefox的配置登陆后就自动同步过来了，所以立马就恢复到了过去的工作环境，果然都是*nix家族，大部分程序基本都是兼容的。

## GNU
原来Mac OS里面的像ls、sed等都是freebsd的，有的参数和gnu的不一样，用起来非常不爽，所以决定换回GNU的。可以用brew把GNU常用的命令装回来，替换掉原来的即可。具体可以参照这篇文章[Install and Use GNU Command Line Tools on Mac OS X](http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/)。

## Emacs
之前在emacsformacosx[^4]下载的Emacs，发现在全屏后，万恶的工具栏又冒了出来，无论怎么都关不掉，后来发现是那个网站编译的Emacs不支持全屏。所以就用brew的Emacs，装了在全屏没有出现工具栏自动冒出来的情况。

``` bash
brew install emacs --cocoa
# 在此之前需要把原来/Applications下面的Emacs.app改个名或者删除
sudo ln -s /usr/local/Cellar/emacs/24.3/Emacs.app /Applications -r
```

## 虚拟桌面
OS X的虚拟桌面有个让我比较蛋疼的地方是，如果一个程序全屏后，它会离开原来的桌面，然后创建一个新的虚拟桌面出来，这个让我非常的恼火。因为我之前都是把每个程序都固定放在一个桌面，然后用`Super + [1-8]`来切换，这个就可以迅速地去到自己想去到的程序那里。

现在暂时没有好的解决方案，所以就暂时不全屏了。

## 窗口切换

原来的窗口切换太坑爹了，不能在只一个虚拟桌面里面切换应用程序，所以找了witch[^5]，这个又要$14美刀，太坑爹了。目前还在用试用版，到时再看看是不是要支持正版了。

## 效率工具

### Alfred
Alfred[^6]应该是Mac上最强的效率工具了，购买Powerpack后功能就会非常强大，而且有大量的workflow可以扩展Alfred。Alfred就像一个非常强大的前端，可以调用后端程序处理，然后返回结果。

具体可以看看知乎：[zhihu](http://www.zhihu.com/question/20656680)

如果支持正版的话，建议购买Mega，这样以后可以免费升级，当时我买了Single License，现在后悔了。到时3.0又要花钱了。

### BetterTouchTool
BetterTouchTool[^3]可以为可以为触摸板定制手势的强大的工具，可以定制单指、双指、三指、四指甚至5指11指的手势，免费的。

## 其他

### QQ
对于QQ的聊天记录，我把它从Windows里面直接复制到了`/Users/cedricporter/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ`这个目录里面，然后重新打开Mac QQ，QQ就提示升级历史记录，然后就把聊天记录迁移到了Mac上面了。

这个是我从07年开始的聊天记录，坚持了7年了。

### 剪切
突然发现Mac下面Finder居然没有文件剪切，难道我要复制后把源文件删除？

后来发现原来是这样的：按`Command+C`复制，然后在目的文件夹按`Command+Option+V`剪切过去。

### 杂
像苹果内置的日历和邮件客户端都非常好用，对于Google的服务支持的非常不错。赞一个。

而且有Evernote、ps、acdsee等等非常优秀的软件可以在Mac OS上面跑，这让我可以彻底离开Windows了。如果打机的话，决定还是买个xbox或者ps4回来玩了。还是比较喜欢高质量一些的游戏。

## Octopress

Octopress安装很正常，就是lsi很有问题，它提示需要安装gsl。我使用`brew install gsl`然后`gem install gsl`后，一直提示：“Notice: for 10x faster LSI support, please install http://rb-gsl.rubyforge.org/”，但是gsl我是装了啊！

搞了很久我在octopress目录用`ruby -e 'p $:'`打印的PATH里面都没有gsl的path，但是真的已经装了啊。纠结了很久，最后在Gemfile里面加上了`gem 'gsl', '~> 1.15.3'`，然后就可以了。

## 终
最后觉得，其实Mac OS的可定制性也是很强的，而且生态圈也非常健康，有许多好用的应用。不过基本上增加一个功能，都需要花钱去买软件来扩展。这个对比起Linux来说还是有些不习惯。例如有一个把顶部全局菜单那里的程序图标隐藏的程序bartender[^2]，就这么简单的一个程序，就要96人民币，真是贵，而且这个功能不是应该系统内置的吗！？

不过Mac OS的好处是，相对于Linux的那些桌面，还是非常稳定的，不会说动不动出现一些非常诡异的问题。毕竟一个是由一堆收费软件构建成的，一个是由开源软件筑成的。

不过想想，程序员也是要吃饭的，所以大部分软件还是收费的质量会高些。


[^1]: [https://github.com/cedricporter/vim-emacs-setting](https://github.com/cedricporter/vim-emacs-setting)

[^2]: [http://www.macbartender.com/](http://www.macbartender.com/)

[^3]: [BetterTouchTool官网](http://www.bttremote.com/)

[^4]: [http://emacsformacosx.com/](http://emacsformacosx.com/)

[^5]: [http://manytricks.com/witch/](http://manytricks.com/witch/)

[^6]: [http://www.alfredapp.com/](http://www.alfredapp.com/)

[^7]: [给笔记本加装了SSD](http://everet.org/2012/02/the-installation-of-the-ssd-to-the-notebook.html)
