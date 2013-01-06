---
layout: post
title: "Chrome Edit With Emacs"
date: 2013-01-05 16:46
comments: true
categories: IT
tags: [Emacs, Chrome, Lisp]
---
大家在浏览器写长篇的东西时，有没觉得那个纯文本编辑框弱爆了？反正我是这么觉得。像Github、[stackoverflow](http://stackoverflow.com/editing-help)、Wiki等都支持Markdown，对于这种有语法的文本，最好就是用个语法高亮自动排版的编辑器编辑。

在Firefox有[It's All Text!](https://addons.mozilla.org/zh-cn/firefox/addon/its-all-text/)这个插件，可以调用外部编辑器。

而在Chrome里面，也有插件，可以调用外部的Emacs进行编辑，而且可以根据规则自动选择模式，非常方便。它的名字叫[Edit With Emacs](http://www.emacswiki.org/emacs/Edit_with_Emacs)。

安装完插件后，Chrome所有的大Textarea都会出现一个蓝色的edit按钮，一按，就可以用Emacs编辑里面的内容了。

{% img /imgs/2013-01-05-chrome-edit-with-emacs.markdown_20130105_170235_21731e8F.png %}

<!-- more -->

我们可以通过修改`edit-server-url-major-mode-alist`这个Association List[^1]来添加网址规则，如下：

``` cl
(when (and (require 'edit-server nil t) (daemonp))
;  (setq edit-server-new-frame nil)
  (edit-server-start))

(setq edit-server-url-major-mode-alist
      '(("github\\.com" . markdown-mode)
	("i\\.everet\\.org" . moinmoin-mode)))
```

Edit With Emacs的工作原理是在Emacs里面开一个服务器，监听9292端口，然后Chrome插件将文本POST到Emacs里面编辑，编辑完再返回回去。

不过它的Emacs端在编辑中文url的textarea会有bug（因为中文在url中被转义成了%xx%xx这种形式，这个%在format的时候没转义好，于是format的时候就SB了），提交了issue不过作者暂时没理，我们自己注释掉`edit-server-find-or-create-edit-buffer`下面的`edit-server-log`就行了（diff：[edit-server.el](https://github.com/cedricporter/vim-emacs-setting/commit/a3069e50fd3bce90ca46be6ba784e47cd9d198ca#emacs/.emacs.d/plugins/edit-server.el)）。

[^1]: [Association Lists](http://www.gnu.org/software/emacs/manual/html_node/elisp/Association-Lists.html)
