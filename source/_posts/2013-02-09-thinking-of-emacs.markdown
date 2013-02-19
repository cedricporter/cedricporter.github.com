---
layout: post
title: "Emacs随想"
date: 2013-02-09 16:05
comments: true
categories: IT
tags: [Emacs, Lisp]
---

By：[Stupid ET](http://EverET.org/about-me)

Emacs在1975年就诞生了，想必比现在绝大多数程序员都要老。现在最新的Emacs已经是24.3.50.7，为了获取最新的特性，我的Emacs都是自己编译最新的开发版。Emacs其实是一个Lisp解释器，有着和Lisp纠缠不清的关系，[我](http://EverET.org/about-me)想这与Richard Stallman本人和MIT人工智能实验室有些许关系。Emacs许多逻辑都是用elisp写的。而所有的配置都可以用elisp编写。

我曾经是一个忠实的Vim用户，不过后来接触了Emacs后就欲罢不能，其中一个重要的原因是Lisp。用Emacs可以让我们有一个很好的机会去学习和使用Lisp。

我们在Emacs中键入`M-x ielm`就可以打开Emacs Lisp交互解释器。可见，在Emacs中接触到Lisp是多么的容易。

<!-- more -->

## Table Of Content

{:no_toc}
1. Will be replaced with the ToC, excluding the "Contents" header
{:toc}

* * * * *

## 两个常用按键

### Ctrl
Emacs的很多按键都需要配合`Ctrl`，而`Ctrl`在US键盘的左下角，按起来手形会比较纠结。所以强烈推荐将`Ctrl`和`Caps Lock`对调。当然如果你有HHKB[^1]就不需要自己去切换了，因为已经物理支持了。于是`Ctrl`就到了左手小拇指的位置。

### Alt
在Emacs中的`M`就是我们的`Alt`，因为`Alt`在空格的旁边，所以我们很容易就用左手大拇指按下。而一个非常常用的快捷键`M-x`，我们可以用左手大拇指同时按下这两个按键。就不用将整个手掌卷起来按。

## 扩展包管理

Emacs里面的扩展多到不计其数，我们如果自己手工安装扩展或者升级扩展是一件非常麻烦的事情。

对于debian或者ubuntu用户，大家是不是非常喜欢apt-get，只需要敲一条命令，你所需要的软件唰唰唰地就装好了。在Emacs中，我们也有这种便利的包管理——el-get[^2]。

自从有了el-get，我就再也没有自己去手工下载升级那些软件包了，而且，el-get可以很好的处理软件包的依赖。例如我们安装Python的智能补全插件jedi[^3]，就只需要键入`M-x el-get-install jedi`，就可以装好jedi、epc、ctables等等。

另外，在el-get的帮助下，我们可以很容易将我们的Emacs配置用版本控制器进行管理而不必将那些插件也纳入版本控制。在没有el-get的情况下，我们虽然可以通过忽略文件来忽略那些插件的文件，但是我们如果在一台全新的计算机将配置clone下来的时候，就没有了我们之前安装的插件了。

而有了el-get，这些问题都得到了解决。el-get会在新计算机中自动为我们安装好我们的插件。[^4]


## 效率

### 移动 ###

#### Ace Jump ####

我们可以围观一下这个[screencast for AceJump](http://emacsrocks.com/e10.html)。虽然说Vim的移动速度非常的快，但是Emacs加上Ace Jump之后，光标的移动速度完全不亚于Vim。

#### switch-window ####

`C-x o`估计是最常用的快捷键之一了，可以跳到其他window。不过如果在window特别多的时候，狂按`C-x o`估计就是比较让人蛋碎了。于是我们可以借助switch window让`C-x o`变得更加便捷。在window数目大于等于3个的时候，switch window就会给window标上“1,2,3……”，然后可以通过“1,2,3……”来选择window。

{% img /imgs/snapshot18_20130209_200041_3390TAZ.png %}

#### windmove ####

想要更加随心所欲地在window间移动，借助windmove[^6]就可以通过上下左右移动了。

#### 快速移动到特定字符 ####

在Vim中，我们可以按下`f`或者是`t`加上某个字符快速定位到光标之后的字符，这个非常的有用。

``` cl go to char
(defun my-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `my-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (let ((case-fold-search nil))
    (if (eq n 1)
        (progn                            ; forward
          (search-forward (string char) nil nil n)
          (backward-char)
          (while (equal (read-key)
                        char)
            (forward-char)
            (search-forward (string char) nil nil n)
            (backward-char)))
      (progn                              ; backward
        (search-backward (string char) nil nil )
        (while (equal (read-key)
                      char)
          (search-backward (string char) nil nil )))))
  (setq unread-command-events (list last-input-event)))
(global-set-key (kbd "C-t") 'my-go-to-char)
```

通过这个，我们可以通过`C-t`加上指定字符向后跳，后者`C-u C-t`向前跳。比如C-t w w w w ...就一直往后跳到后续的w处。类似于Vim中的fw;;;...


### 标记Mark ###

标记，估计是最常用的功能之一。默认的Set Mark命令是`C-@`或者是`C-SPC`，前者太难按（Ctrl-Shitf-2），后者和输入法冲突了。于是我们可以将其重新绑定为`M-SPC`，这样用两个大拇指就可以轻松Set Mark了。

``` cl 重新设置mark set
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "M-SPC") 'set-mark-command)
```

对于标记一块区域，像Vim中，我们可以`vi(`，`vi"`等等就可以标记括号，或者引号里面的内容了。在Emacs中，我们可以享有这种便捷。我们需要借助expand-region[^7]，具体可以围观视频：[Emacs Rocks! Episode 09: expand-region](http://emacsrocks.com/e09.html)。

而标记一个函数，可以用`C-M-h`。往后标记`C-M-SPC`。


### window ###

#### 分割 ####

控制window的快捷键为

- `C-x 1`：关闭其他window
- `C-x 2`：在下面分割一个window出来
- `C-x 3`：在右边创建一个window
- `C-x 0`: 关闭当前window

这个都有些不太直接，我们将其重新绑定到更快的绑定上。

``` cl
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "M-0") 'delete-window)
```

然后就可以缩短了分割window的键程。

#### 对调buffer ####

如果我们有两个window，有时我们想切换左右或者上下window里面的内容，就可以通过以下脚本：

``` cl
(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))
(global-set-key (kbd "M-9") 'transpose-buffers)
```

### eval lisp ###

我们经常会修改配置文件，一种让配置生效的方法是关闭Emacs，然后重新打开它。不过这也太慢了，如果不是到了迫不得已的情况，我们不需要如此大动干戈来使我们的修改生效。

我们在很多人的博客中都会看到一种方法，`M-x eval-buffer`，嗯，(eval-buffer)可以重新解释运行一遍当前buffer的内容。在挺多时候还是挺有用的。

不过我们有时候仅仅只是修改了一小段配置，完全没有必要eval整个buffer。于是我们就可以eval一个局部。

``` cl eval-region
(define-key emacs-lisp-mode-map (kbd "C-x C-r") 'eval-region)
(define-key lisp-interaction-mode-map (kbd "C-x C-r") 'eval-region)
```

然后，我们选择一个区域后，就可以用`C-x C-r`来eval一个选区了。

### Daemon ###

Emacs使用Client/Server可以大大提高新Emacs的开启速度，所有的client共用server来处理数据。

#### Server ####

首先添加一个开机启动，这个会启动一个Emacs Daemon进程。

`emacs --daemon`

#### Client ####

##### Terminal #####

编辑~/.bashrc，加上

``` bash
alias ec='emacsclient -t -a=""'
alias se='SUDO_EDITOR="emacsclient -t" sudo -e'
```

然后，就可以通过`ec filename`来用emacs编辑文件。开启速度绝对不亚于Vim。

##### Desktop #####

修改快捷方式的的command为

``` bash
emacsclient -c -a=""
```

不过，我觉得Desktop的Emacs不需要连接Daemon，因为Desktop的Emacs只需要开一次就好了。Daemon会有一些奇葩的问题，例如session似乎就没法保存。使用Daemon主要是为了提高开启速度，这个在Terminal中经常开关Emacs编辑文件时就很重要。而在desktop就开一次的情况就显得没什么了。

## eshell ##

eshell是用lisp实现的shell，具有跨平台、支持tramp、与Emacs水乳交融等等优点。

对于如此常用的功能，我们赶紧绑定一个好用快捷键：

`(global-set-key [f4] 'eshell)`

### alias ###

我们可以在lisp中定义alias，也可以专门为eshell定义alias。

``` cl Alias in lisp
(defalias 'll '(eshell/ls "-l"))
(defalias 'ff 'find-file)
```

或者在`~/.emacs.d/eshell/alias`中定义我们在eshell中的alias：

``` sh alias
alias l ls $*
alias la ls -a $*
alias gp git push
alias gs git status
```

Eshell有个挺好的教程：[A Complete Guide to Mastering Eshell](http://www.masteringemacs.org/articles/2010/12/13/complete-guide-mastering-eshell/)。


## TRAMP ##

TRAMP的全写为：Transparent Remote (file) Access, Multiple Protocol。在TRAMP的帮助下，我们可以很容易做到无缝编辑远程文件。

详细阅读：[Emacs Tramp 详解](http://blog.donews.com/pluskid/archive/2006/05/06/858306.aspx)

## 文件管理dired ##

dired是Emacs自带的文件管理系统，能够和tramp无缝配合使用。

{% img /imgs/snapshot20_20130210_125016_1347768h.png %}

默认的dired看上去显示太多东西了，我们可以通过dired的扩展来定制我们需要显示的东西。

我们用el-get很容易就安装好dired扩展"dired-details"和"dired-details+"。然后就可以定制dired显示内容了。默认会隐藏掉不那么常用的信息。如下：

{% img /imgs/snapshot19_20130210_125029_13477HHo.png %}

当按下`)`就可以显示详细信息了。


## Development ##


### autocomplete ###

autocomplete[^9]可以为我们提供类似常用IDE一样的弹出式提示。而补全来源也可以轻松的自定义，是一个非常好的补全框架。

{% img /imgs/snapshot22_20130217_114849_2411dZJ.png %}

### Yasnippet ###

Yasnippet是一个非常强大的模板替换扩展，可以轻松自己定制模板，而且模板还可以嵌入lisp进行逻辑处理，非常强大。

可以围观视频：[Emacs Rocks! Episode 06: Yeah! Snippets!](http://emacsrocks.com/e06.html)

### Python ###

作为一个Python程序员，拥有一个好用的Python开发环境是非常的重要的。

相信大家在网上找到的Emacs Python IDE搭建靠的都是PyMacs和Rope。Rope是一个很强的库，不仅可以用来补全，还可以用来重构等等。

不过Rope的补全速度非常的缓慢，于是我们可以求助一个更强更迅速的补全库jedi[^5]，这是一个异步的补全库，不会阻塞编辑。而且jedi已经对autocomplete有很好的兼容了。安装仅需要`M-x el-get-install jedi`。

### Lisp ###

Emacs本来就是一个很好的elisp开发环境。不过Lisp里面的括号非常非常多，很容易就被搞晕了，一个有效的括号高亮显得非常重要。

{% img /imgs/snapshot21_20130217_113058_2411QPD.png %}

达到上述逐级高亮的效果，需要借助highlight-parentheses，autopair。然后编写下述代码[^8]。

``` cl 括号高亮
(add-hook 'highlight-parentheses-mode-hook
          '(lambda ()
             (setq autopair-handle-action-fns
                   (append
                    (if autopair-handle-action-fns
                        autopair-handle-action-fns
                      '(autopair-default-handle-action))
                    '((lambda (action pair pos-before)
                        (hl-paren-color-update)))))))

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)
```

### 其他 ###

像Emacs中的开发辅助插件还有很多，比较重型的有cedet(Collection of Emacs Development Environment Tools)、ecb(Emacs Code Browser)等等，都是有效的工具，可以帮助我们提高工作效率。


## Misc ##

- `M-&` 异步运行一个shell命令
- `M-:` 运行一句lisp
- `M-z` 删除到某个字符，同Vim的`df`
- `M-h` 标记一段
- `C-M-h` 标记一个函数定义
- `C-h C-a` about-emacs
- `C-x C-+` and `C-x C--` to increase or decrease the buffer text font size


## 终 ##

写了好几天，发现还有挺多东西没写的，Emacs博大精深，还需要自己慢慢摸索。这里纯当为我的记忆做个快照，让以后的我可以看到在2013年初时，Emacs在我眼中的形象。

如果你阅读到了这里，非常感谢你的耐心，感谢你看完了我如此长篇的唠叨。祝你在2013年效率大大提高～


## 有趣的Emacs知识分享

1. <http://whattheemacsd.com/>
1. <http://emacsrocks.com/>


## Footnotes

[^1]: <http://zh.wikipedia.org/wiki/HHKB>

[^2]: <https://github.com/dimitri/el-get>

[^3]: <https://github.com/tkf/emacs-jedi>

[^4]: [我的el-get配置](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-el-get-settings.el)

[^5]: [emacs-jedi](https://github.com/tkf/emacs-jedi)

[^6]: <http://emacswiki.org/emacs/WindMove>

[^7]: <https://github.com/magnars/expand-region.el>

[^8]: <http://www.emacswiki.org/HighlightParentheses>

[^9]: <http://cx4a.org/software/auto-complete/>
