---
layout: post
title: "Emacs随想"
date: 2013-02-09 16:05
comments: true
categories: IT
tags: [Emacs, Lisp]
toc: true
---

By：[Stupid ET](http://EverET.org/about-me)

Emacs在1975年就诞生了，想必比现在绝大多数程序员都要老。现在最新的Emacs已经是24.3.50.7，<del>为了获取最新的特性，我的Emacs都是自己编译最新的开发版</del>（在24.3正式版出了后就使用正式版了，正式版更为稳定）。Emacs其实是一个Lisp解释器，有着和Lisp纠缠不清的关系，[我](http://EverET.org/about-me)想这与Richard Stallman本人和MIT人工智能实验室有些许关系。Emacs许多逻辑都是用elisp写的。而所有的配置都可以用elisp编写。

我曾经是一个忠实的Vim用户，不过后来接触了Emacs后就欲罢不能，其中一个重要的原因是Lisp。用Emacs可以让我们有一个很好的机会去学习和使用Lisp。

我们在Emacs中键入`M-x ielm`就可以打开Emacs Lisp交互解释器。可见，在Emacs中接触到Lisp是多么的容易。

<!-- more -->

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


### 辅助插件 ###

#### Helm

Helm可以方便地帮助我们找到想要的buffer、文件。而且看上去也很酷。

{% img /imgs/snapshot23_20130227_104506_4247DHx.png %}

#### smex

smex提供了更好的M-x体验。它让M-x变成了像ido一样，可以实时提供补全。让M-x更加快速。

{% img /imgs/snapshot24_20130227_104955_42471QA.png %}

#### session

配合desktop可以保存我们上一次的工作状态。也就是重新打开Emacs的时候，会变成上次关闭的状态。

#### undo-tree ####

Emacs的undo非常诡异，只有undo，没有redo。如果要redo，那只有undo undo。

Emacs可以帮你所有的修改记录都保存下来，我们可以肆意地修改、undo完修改，各种修改，我们都可以回到曾经的状态。这个是其他编辑器难以做到的。

undo-tree可以将所有的状态用树状结构绘制出来。然后我们轻松地可以找到我们需要的状态。

我们按`C-x u`可以进入undo-tree-visualizer-mode, 然后 `p`、`n` 上下移动，在分支之前 `b`、`f` 左右切换，`t` 显示时间戳，选定需要的状态后， `q`退出。这是主要的操作，其它的自己摸索好了…… [^10]

### 宏 ###

#### 录制 ####

开始录制宏，用`C-x (`； 结束录制宏，用`C-x )`；

#### 使用 ####

用`C-x e`来使用宏。可以利用`C-u`来重复使用100次这个宏，即命令`C-u 100 C-x e`。
`C-x e e e ...`将宏重复。

#### 保存宏 ####

1. 为宏命名：`M-x name-last-kbd-macro`。
1. 在配置文件的某个地方输入`M-x insert-kbd-macro`。
1. 然后就可以通过`M-x`调用了。


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

## 调试Emacs扩展 ##

有时候Emacs的插件会出现各种问题，我们就需要进行调试了。

如果我们希望在出现错误的时候能够自动进入调试模式，那我们可以`M-x toggle-debug-on-error`。

如果有时候Emacs卡住没有反应，但是按`C-g`能够恢复的话，那说明可能是进入了死循环。我们可以在之前打开`M-x toggle-debug-on-quit`，然后在我们按`C-g`的时候就可以调试当前正在运行的elisp。

那有时候我们需要在某个elisp函数设置断点的话，我们可以通过`M-x debug-on-entry [funcname]`来为某个函数设置断点。取消断点可以通过`M-x cancel-debug-on-entry`。

在我们进入调试模式的时候，按`d`可以单步，`q`退出，`e`执行lisp。

详细：[Debugger Commands](http://www.gnu.org/software/emacs/manual/html_node/elisp/Debugger-Commands.html)


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



## 帮助 ##

如果在使用Emacs的过程中遇到什么问题，可以求助于Emacs的帮助系统。

### C-h t
打开 Emacs 的入门教程，

### C-h k
让Emacs告诉你某个快捷键是什么作用。首先按下`C-h k`，然后按下我们的快捷键。就可以打开帮助了，于此同时，我们还可以看到我们的按键的是如何表示的。

### C-h b
查看按键绑定

### C-h K
注意这次是大写的 K 。对于 Emacs的一些内部命令，除了Elisp源代码中提供的文档以外，还有一个专门的 Info 文档进行了系统的介绍。C-h K 就是定位到 Info 文档中描述该命令的位置。

### C-h f
查看某个函数的文档。建议绑定一个快捷键，这样我们把光标放到某个函数的上面，一按快捷键就可以打开这个函数的文档了。

### C-h v
查看某个变量的文档。

### C-h m
当开当前mode的帮助。这里挺详细的对于当前可以快捷键的描述。

### ... C-h
当我们不能完整记得某些快捷键的时候，可以按下前缀后，再按下`C-h`。就可以看到以这个前缀开始的快捷键有哪些。

### C-h a 更模糊的查找
有些时候我们只知道一个关键字，这个时候可以用 `C-h a` 来通过正则表达式来查找命令名。Emacs 会列出所有匹配的命令以及一个简短的文档，并可以通过点击链接定位到该命令的详细文档。


## Misc ##

### 一些快捷键 ###

- `C-M-h` 标记一个函数定义
- `C-h C-a` about-emacs
- `C-h C` 查看当前文件的编码
- `C-u M-! date` 插入当前时间
- `C-u M-=` 计算整个缓冲区的行数、字数和单词数
- `C-x <RET> f utf-8` （set-buffer-file-coding-system），设置当前buffer的文件的编码
- `C-x C-+` and `C-x C--` to increase or decrease the buffer text font size
- `C-x C-q` 开关read-only-mode，在dired-mode中可以进入修改模式，可以批量修改文件名。
- `C-x C-t` 交换两行。可以用来调整python中import
- `C-x C-v` or `M-x find-alternate-file` 重新打开当前文件，在高亮后者插件出了bug可以用这个命令重新加载。
- `C-x z` 重复上一条命令。可以一直按`z`不断执行，非常方便！
- `M-&` 异步运行一个shell命令
- `M-:` 运行一句lisp
- `M-@` mark-word，连续按连续mark单词。
- `M-g M-g linenum` 跳到某行，同vim中的`[linenum]G`
- `M-h` 标记一段
- `M-x dig`
- `M-x ifconfig`
- `M-x ping`
- `M-x telnet`
- `M-z` 删除到某个字符，同Vim的`df`
- `C-u M-! date` 插入当前时间
- `C-q C-i` 插入tab


### 中文输入法 ###

在英文版的系统里面，一般情况下Emacs可能打不开中文输入法，此时我们需要修改LC_CTYPE环境变量就好了。

可以在~/.profile最后加上一句

```
export LC_CTYPE="zh_CN.UTF-8"
```

### 字节码编译
将我们的el配置编译成字节码，可以加快Emacs的加载速度，特别是在配置文件特别多的时候。

我们去到我们的el配置文件目录，打开`dired`，然后输入`% m`来调用`dired-mark-files-regexp`，然后输入`.el`来标记所有的配置文件，然后按`B`调用`dired-do-byte-compile`，然后就可以把一个目录下面的el一次性编译成`elc`。或者也可以直接`C-u 0 M-x byte-recompile-directory`一次性编译一个目录及其子目录。

不过这样就会带来一个问题，就是如果我们修改了配置后，还是需要重新编译的。这里在ErgoEmacs[^11]找到了自动重新编译的配置，就是在保存文件的时候检查当前是否为`emacs-lisp-mode`，如果是，那么就编译它。这样我们修改配置的时候，就会自动重新编译了。

``` scheme
;; http://ergoemacs.org/emacs/emacs_byte_compile.html
(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

(add-hook 'after-save-hook 'byte-compile-current-buffer)
```


## 终 ##

写了好几天，发现还有挺多东西没写的，Emacs博大精深，还需要自己慢慢摸索。这里纯当为我的记忆做个快照，让以后的我可以看到在2013年初时，Emacs在我眼中的形象。

如果你阅读到了这里，非常感谢你的耐心，感谢你看完了我如此长篇的唠叨。祝你在2013年效率大大提高～

如果你有兴趣，可以浏览一下[我的Emacs配置文件](https://github.com/cedricporter/vim-emacs-setting/tree/master/emacs)。


## 有趣的Emacs知识分享

1. <http://whattheemacsd.com/>
1. <http://emacsrocks.com/>

## Update

### 2014-08-20

1. 更新字节码编译 [diff](https://github.com/cedricporter/cedricporter.github.com/commit/c857d56079e935e03c877d285f9a55610126f706#diff-b200e88495777770f365b922b7fbe419)


[^1]: <http://zh.wikipedia.org/wiki/HHKB>

[^2]: <https://github.com/dimitri/el-get>

[^3]: <https://github.com/tkf/emacs-jedi>

[^4]: [我的el-get配置](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-el-get-settings.el)

[^5]: [emacs-jedi](https://github.com/tkf/emacs-jedi)

[^6]: <http://emacswiki.org/emacs/WindMove>

[^7]: <https://github.com/magnars/expand-region.el>

[^8]: <http://www.emacswiki.org/HighlightParentheses>

[^9]: <http://cx4a.org/software/auto-complete/>

[^10]: <http://linuxtoy.org/archives/emacs-undo-tree.html>

[^11]: <http://ergoemacs.org/emacs/emacs_byte_compile.html>
