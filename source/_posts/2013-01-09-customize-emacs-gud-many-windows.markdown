---
layout: post
title: "定制Emacs GDB调试窗口布局"
date: 2013-01-09 01:06
comments: true
categories: IT
tags: [Emacs, Lisp]
---
我们在Emacs中可以方便地使用GDB，具体操作在[emacser.com](http://emacser.com/emacs-gdb.htm)有详细的快捷键的教程。不过我觉得其实GDB的CLI已经很好用了。

Emacs中默认可以方便打开多窗格模式，看起来就很像平时大家用的IDE了。

我们只需要`M-x gdb-many-windows`就可以打开多窗格了，默认布局如下图：

{% img /imgs/snapshot4_20130109_011149_15479HnD.png %}

我们可以看到有6个窗格，其中有GDB命令行、局部变量、源代码、程序输出、栈、断点。功能看上去虽然很强大，不过我常用的只有其中几个，于是就决定开始定制Emacs的GDB调试窗口布局。

<!-- more -->

我常用的是代码框、输出、GDB命令行以及栈，什么断点、局部变量基本可以在需要的时候用`i b`，`i locals`查看就可以了，没必要弄这么小一个窗格占住位置，而且想看的时候还看不完整。


## 定制

于是开始按照我的心意，将其定制成如下这样。

{% img /imgs/snapshot5_20130109_011857_15479UxJ.png %}

这样用起来比较爽，没有不需要的窗格。各位看官也可以根据自己的需要配置。

`gdb-many-windows`的窗口布局是写死在`gdb-setup-windows`这个函数里面，我们最好的方法就是`defadvice`这个函数。代码如下：

``` cl
(defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
  "my gdb UI"
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))        
        (win1 (split-window nil nil 'left))      ;code and output
        (win2 (split-window-below (/ (* (window-height) 2) 3)))     ;stack
        )
    (select-window win2)
    (gdb-set-window-buffer (gdb-stack-buffer-name))
    (select-window win1)
    (set-window-buffer
     win1
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (if gdb-main-file
           (gud-find-file gdb-main-file)
         ;; Put buffer list in window if we
         ;; can't find a source file.
         (list-buffers-noselect))))
    (setq gdb-source-window (selected-window))
    (let ((win3 (split-window nil (/ (* (window-height) 3) 4)))) ;io
      (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win3))
    (select-window win0)
    ))
```

经过`defadvice`就可以修改原来定义的函数了，从而我们就可以定制UI了。

> Emacs是伪装成编辑器的操作系统～～～




