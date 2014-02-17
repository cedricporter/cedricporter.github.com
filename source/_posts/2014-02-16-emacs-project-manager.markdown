---
layout: post
title: "Emacs分项目保存session"
date: 2014-02-16 23:50
comments: true
categories: IT
tags: [Emacs, Lisp]
---

有时候我们在同时写多个不同的项目，这个时候，我们可能会打开多个不同的Emacs实例，然后在不同的Emacs实例中以项目为单位打开文件来编辑。

## 恢复关闭前的环境
desktop[^2]和session[^1]是Emacs用来保存会话用的，下次打开的时候可以恢复到上次一次关闭状态，还是非常方便的。例如一个项目打开了许多文件（Buffer），关闭之后，在下次打开的时候又可以恢复到之前的状态，就可以避免重新打开一堆buffer恢复工作状态的尴尬情况。这样我们的Emacs就像没有关闭过一样。

## 问题
这个时候问题就来了，如果我们开了多个Emacs分别在写多个不同的项目，这个时候怎么办呢？

<!-- more -->

默认情况下，Emacs会在`~/.emacs.d`下面创建`.emacs.desktop`文件，用来保存当前的环境。

很明显，如果有多个不同的项目，就会有多个不同的文件集合，所以就明显不能共用同一个`.emacs.desktop`。

## 解决

解决这个问题的一个方法是，在每个不同的项目文件夹的根目录创建一个`.emacs.desktop`，然后保存自己这个项目的环境。

我们可以`M-x desktop-change-dir`，然后将目录切换到项目的路径，然后就可以加载和保存那个项目的`.emacs.desktop`了。

为了方便，我们可以设置快捷键来切换。

``` cl
(global-set-key (kbd "C-x g d") 'desktop-change-dir)
```

然后我们就可以通过`C-x g d`，然后输入项目的路径，就可以加载那个项目之前的开发环境，就可以还原打开的buffer，历史等等。

对于有些常用的项目，我们可以设置固定的快捷键来快速加载它们。

``` cl
(setq session-key-dir-map '(("c" "~/git/vipbar-b2c")
                            ("b" "~/svn/vipbar")
                            ("o" "~/octopress")
                            ))
(while session-key-dir-map
  (lexical-let* ((item (car session-key-dir-map))
                 (key (car item))
                 (path (car (cdr item))))
    (global-set-key (kbd (concat "C-x g g " key))
                    #'(lambda () (interactive) (desktop-change-dir path)))
    (setq session-key-dir-map (cdr session-key-dir-map)))
  )
```

这里我设置了`C-x g g `前缀，例如使用`C-x g g o`这个快捷键，我就加载`~/octopress/.emacs.desktop`，就可以恢复之前写博客时关闭环境。使用`C-x g g c`就可以打开vipbar-b2c这个项目之前关闭的时候保存的状态，就可以恢复到上次关闭Emacs的时候的状态。

## 其他
如果我们将`.emacs.desktop`放置到项目的根目录，对于版本控制器，我们就需要忽略这个文件了。

我们需要忽略的文件包括：`.emacs.desktop`和`.emacs.desktop.lock`这两个文件。可以在全局忽略它们。

对于svn，可以编辑`~/.subversion/config`，在`global-ignores`后面加上`.emacs.desktop .emacs.desktop.lock`。

对于git，可以在`~/.gitignore`里面加上

```
.emacs.desktop
.emacs.desktop.lock
```

然后`git config --global core.excludesfile '~/.gitignore'`这样全局忽略这两个文件。




[^1]: [Emacs Session](http://www.emacswiki.org/emacs/EmacsSession)

[^2]: [Emacs Desktop](http://www.emacswiki.org/emacs/DeskTop)
