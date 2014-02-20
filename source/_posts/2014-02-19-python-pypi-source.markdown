---
layout: post
title: "修改pip/setup.py的源"
date: 2014-02-19 21:24
comments: true
categories: IT
tags: [Python]
---

今天在用setup.py安装我们项目代码的时候，发现在安装依赖包的时候，连接一直被墙了。

看到log输出是从[https://pypi.python.org/simple/](https://pypi.python.org/simple/)下载包的。

我想修改成douban的源。于是找了一下怎么设置源。

<!-- more -->

找到最多的是这个例子，首先我是在`~/.pip/pip.conf`里面写了

``` ini ~/.pip/pip.conf
[global]
index-url = http://pypi.douban.com/simple
```

发现用pip安装东西，确实是从douban的源下载的，不过使用setup.py安装的时候，还是从默认的pypi.python.org下载的。

看来需要的是distutils的配置。找了一下，发现是可以通过`~/.pydistutils.cfg`来配置distutils的源[^1]。如下：

``` ini ~/.pydistutils.cfg
[easy_install]
index_url = http://pypi.douban.com/simple
```

然后就可以在setup.py安装依赖的时候使用豆瓣源了。

## 探索setup.py

**为啥读的是**`~/.pydistutils.cfg`**这个文件呢？**于是我决定去distutils源码的目录围观一下，`grep pydistutils.cfg *`后发现dist.py里面有个函数： 

``` python
    def find_config_files(self):
        """Find as many configuration files as should be processed for this
        platform, and return a list of filenames in the order in which they
        should be parsed.  The filenames returned are guaranteed to exist
        (modulo nasty race conditions).

        There are three possible config files: distutils.cfg in the
        Distutils installation directory (ie. where the top-level
        Distutils __inst__.py file lives), a file in the user's home
        directory named .pydistutils.cfg on Unix and pydistutils.cfg
        on Windows/Mac; and setup.cfg in the current directory.

        The file in the user's home directory can be disabled with the
        --no-user-cfg option.
        """
        files = []
        check_environ()

        # Where to look for the system-wide Distutils config file
        sys_dir = os.path.dirname(sys.modules['distutils'].__file__)

        # Look for the system config file
        sys_file = os.path.join(sys_dir, "distutils.cfg")
        if os.path.isfile(sys_file):
            files.append(sys_file)

        # What to call the per-user config file
        if os.name == 'posix':
            user_filename = ".pydistutils.cfg"
        else:
            user_filename = "pydistutils.cfg"

        # And look for the user config file
        if self.want_user_cfg:
            user_file = os.path.join(os.path.expanduser('~'), user_filename)
            if os.path.isfile(user_file):
                files.append(user_file)

        # All platforms support local setup.cfg
        local_file = "setup.cfg"
        if os.path.isfile(local_file):
            files.append(local_file)

```

这里有写有加载啥，所以我们直接在setup.py的同目录放置一个`setup.cfg`，也可以达到同样的效果。

``` ini setup.cfg
[easy_install]
index_url = http://pypi.douban.com/simple
```

## 结

加上配置后`python setup.py install`安装的时候，依赖就会从douban的源下载了。

用setup.cfg的好处是，这样源的配置就可以跟着源码走了。以后在其他机器上面安装的时候也可以用到douban的源。

[^1]: [https://pypi.python.org/pypi/pypiserver](https://pypi.python.org/pypi/pypiserver)
