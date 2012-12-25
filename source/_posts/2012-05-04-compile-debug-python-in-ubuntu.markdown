---
comments: true
date: 2012-05-04 20:38:05
layout: post
slug: compile-debug-python-in-ubuntu
title: 在Ubuntu下编译调试版的Python
wordpress_id: 992
categories:
- Linux
tags:
- Python
---

在Windows调试Python解释器还是非常方便的，因为有强大的VS。

不过在Linux下可能有点不那么顺畅。但是稍微设置一下还是可以很方便地调试的。我们来看看在Ubuntu下怎么做。


## 获取源码


在Ubuntu下获取Python2.7的源码非常方便，只需要使用apt-get就可以轻松取得。在Shell下输入


> apt-get source python2.7


即可以将Python的源码下载到当前目录。

然后我们就可以得到一个tar.gz的压缩包。


## 编译


我们进入源码文件夹后输入

```
./configure
make
```

然后就可以编译得到python。

当然，此时的Python不是调试版的，如果要编译调试版的Python，就需要再做一些东西。首先我们可以Google一下怎么做，貌似很多都是引用了源码README的一段话：<!-- more -->


> command; e.g. "make OPT=-g" will build a debugging version of Python
on most platforms. The default is OPT=-O; a value for OPT in the
environment when the configure script is run overrides this default
(likewise for CC; and the initial value for LIBS is used as the base
set of libraries to link with).


好，我们现在使用

`make OPT=-g`

试试，嗯，确实用gdb可以调试了，不过单步的时候会在源码那里会一下在上一下在下地跳来跳去。而且查看变量值的时候很多变量显示的是<optimized out>。原因是编译的时候优化了。那优化选项什么时候被加进去了？

我们来看看configure生成的Makefile中的一段。


```
# Compiler options
OPT= -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes
BASECFLAGS= -fno-strict-aliasing
CFLAGS= $(BASECFLAGS) -g -O2 $(OPT) $(EXTRA_CFLAGS)
# Both CPPFLAGS and LDFLAGS need to contain the shell's value for setup.py to
# be able to build extension modules using the directories specified in the
# environment variables
CPPFLAGS= -I. -IInclude -I$(srcdir)/Include
```

可以看到OPT的-O3已经被我们的OPT=-g参数覆盖掉了，不过还有一个-O2在CFLAGS那里。呃，原来源码的README还是不可靠的啊。

我们现在来重新编译：

{% codeblock console lang:console %}
make clean
make -j4 OPT=-g CFLAGS=-g
{% endcodeblock %}


这样编译的时候gcc就不会优化代码了。我们单步的时候就不会跳来跳去，变量的值也不会出现`<optimized out>`。

另外“-j4”选项是指开4个gcc编译，我是2核处理器，所以开4个gcc编译会快些。

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-04-202058.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-04-202058.png)
