---
layout: post
title: "Emacs随想"
date: 2014-08-21 16:05
updated: 2014-08-21 10:05
comments: true
categories: IT
tags: [Emacs, Lisp]
toc: true
---

By：[Stupid ET](http://EverET.org/about-me)

Emacs在1975年就诞生了，想必比现在绝大多数程序员都要老。现在最新的Emacs已经是24.3.50.7，<del>为了获取最新的特性，我的Emacs都是自己编译最新的开发版</del>（在24.3正式版出了后就使用正式版了，正式版更为稳定）。Emacs其实是一个Lisp解释器，有着和Lisp纠缠不清的关系，[我](http://everet.org/thinking-of-emacs.html)想这与Richard Stallman本人和MIT人工智能实验室有些许关系。Emacs许多逻辑都是用elisp写的。所有的配置也都是用elisp编写。

<!-- more -->

## 0x01 初见

想起很久很久以前，第一次因为久闻Emacs大名打开了Emacs，看到这界面，不禁吐槽，这不就是一个Notepad吗？完全看不出这货竟然被尊称为「伪装成编辑器的操作系统」啊。

{% img /imgs/QQ20140820-1_20140820_202137_35033BH1.png 540 %}

而且发现完全可以像用Notepad一样使用Emacs-.-（想想第一次打开Vim的童鞋们可能连输入都发现没反应）。

鉴于众大牛都推荐Emacs，我还是决定尝试一下Emacs。刚开始完全无法忍受着`C-[pnbf]`的上下左右操作方式，找了一下发现有个Evil[^12]插件，装上它Emacs立即拥有Vim的按键绑定，于是Emacs就这么变成了Vim！于是之后的一年我都是这么用的Emacs。

## 0x02 相识

我曾经是一个忠实的Vim用户（当然现在还是），不过后来接触了Emacs后就欲罢不能，其中一个重要的原因是Lisp。用Emacs可以让我们有一个很好的机会去学习和使用Lisp。

我们在Emacs中键入`M-x ielm`就可以打开Emacs Lisp交互解释器。可见，在Emacs中接触到Lisp是多么的容易[^13]。

{% img /imgs/QQ20140820-3_20140820_220150_35033BOp.png 540 %}

于是随着时间的推移，更多地把玩，开始逐渐对Emacs刮目相看，发现Emacs真的是「伪装成编辑器的操作系统」。于是调教Emacs成了茶余饭后的消遣活动。

## 0x03 两个按键

### Ctrl

作为一个被称为「Ctrl到死」的编辑器的用户，我们需要好好思考一下Ctrl这个按键。

Emacs的很多按键都需要配合`Ctrl`，而`Ctrl`在US键盘的左下角，按起来手形会比较纠结。所以强烈推荐将`Ctrl`和`Caps Lock`对调。当然如果你有HHKB[^1]就不需要自己去切换了，因为已经物理支持了。于是`Ctrl`就到了左手小拇指的位置，按起来就非常舒适了。

### Meta
在Emacs中的`M`(Meta)就是我们的`Alt`，因为`Alt`在空格的旁边，所以我们很容易就用左手大拇指按下。而一个非常常用的快捷键`M-x`，我们可以用左手大拇指同时按下这两个按键。就不用将整个手掌卷起来按。对于Mac用户，因为Mac的键盘`Alt`在普通键盘的Win键的位置，所以需要调换一下：

``` cl
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
```

## 0x04 扩展包管理

Emacs里面的扩展多到不计其数，我们如果自己手工安装扩展或者升级扩展是一件非常麻烦的事情。

对于debian或者ubuntu用户，大家是不是非常喜欢apt-get，只需要敲一条命令，你所需要的软件唰唰唰地就装好了。在Emacs中，我们也有这种便利的包管理——el-get[^2]。

自从有了el-get，我就再也没有自己去手工下载升级那些软件包了，而且，el-get可以很好的处理软件包的依赖。例如我们安装Python的智能补全插件jedi[^3]，就只需要键入`M-x el-get-install jedi`，就可以装好jedi、epc、ctables等等，而且升级也非常方便。

另外，在el-get的帮助下，我们可以很容易将我们的Emacs配置用版本控制器进行管理，而不必将那些插件也纳入版本控制。在没有el-get的情况下，我们虽然可以通过忽略文件来忽略那些插件的文件，但是我们如果在一台全新的计算机将配置clone下来的时候，就没有了我们之前安装的插件了。

而有了el-get后，这些问题都得到了解决。el-get会在新计算机中自动为我们下载并安装好我们的插件。我用el-get管理了挺多插件，可以围观[el-get配置](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-el-get-settings.el)。

## 0x05 效率

作为Emacs User，使用效率也是十分重要。Emacs经过扩展后，可以比原版高效非常非常多。

### 移动 ###

#### Ace Jump ####

我们可以围观一下这个[screencast for AceJump](http://emacsrocks.com/e10.html)。虽然说Vim的移动速度非常的快，但是Emacs加上Ace Jump之后，光标的移动速度完全不亚于Vim。

#### switch-window ####

`C-x o`估计是最常用的快捷键之一了，可以跳到其他window。不过如果在window特别多的时候，狂按`C-x o`估计就是比较让人蛋碎了。于是我们可以借助switch window让`C-x o`变得更加便捷。在window数目大于等于3个的时候，switch window就会给window标上“1,2,3……”，然后可以通过“1,2,3……”来选择window。

{% img /imgs/QQ20140820-5_20140820_221604_35033bi1.png 600 %}

#### windmove ####

想要更加随心所欲地在window间移动，可以借助windmove[^6]就可以通过上下左右移动了。我设了这些快捷键来移动：

``` cl
(global-set-key (kbd "C-S-j") 'windmove-down)
(global-set-key (kbd "C-S-k") 'windmove-up)
(global-set-key (kbd "C-S-h") 'windmove-left)
(global-set-key (kbd "C-S-l") 'windmove-right)
```

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

### 快速编辑
Sublime Text中引以为傲的多光标编辑，Emacs装个[multiple-cursors.el](https://github.com/magnars/multiple-cursors.el)就可拥有。

Multiple Cursors让Emacs轻松就可以像Vim的`C-v`列编辑，还有可以更高级的多光标编辑。可以看视频：[Episode 13: multiple-cursors](http://emacsrocks.com/e13.html)。


### 标记Mark ###

标记，估计是最常用的功能之一。默认的Set Mark命令是`C-@`或者是`C-SPC`，前者太难按（Ctrl-Shitf-2），后者和输入法冲突了。于是我们可以将其重新绑定为`M-SPC`，这样用两个大拇指就可以轻松Set Mark了。

``` cl 重新设置mark set
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "M-SPC") 'set-mark-command)
```

对于标记一块区域，像Vim中，我们可以`vi(`，`vi"`等等就可以标记括号、或者引号里面的内容了。在Emacs中，我们可以享有这种便捷。我们需要借助`expand-region`[^7]，具体可以围观视频：[Emacs Rocks! Episode 09: expand-region](http://emacsrocks.com/e09.html)。

而标记一个函数，可以用`C-M-h`。往后标记`C-M-SPC`。


### window管理 ###

#### 分割 ####

对于非常常用的window分割快捷键默认为

- `C-x 1`：关闭其他window
- `C-x 2`：在下面分割一个window出来
- `C-x 3`：在右边创建一个window
- `C-x 0`: 关闭当前window

这些都有点不太直接，我们将其重新绑定到更快的按键上：

``` cl
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "M-0") 'delete-window)
```

这样就缩短了分割window的键程，畅快许多。

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

更多window布局配置可以围观[window-setting.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/window-setting.el)

### 快速eval lisp ###

我们经常会修改配置文件，一种让配置生效的方法是关闭Emacs，然后重新打开它。不过这也太慢了，如果不是到了迫不得已的情况，我们不需要如此大动干戈来使我们的修改生效。

我们在很多人的博客中都会看到一种方法，`M-x eval-buffer`，嗯，(eval-buffer)可以重新解释运行一遍当前buffer的内容。在挺多时候还是挺有用的。

不过我们有时候仅仅只是修改了一小段配置，完全没有必要eval整个buffer。于是我们就可以eval一个局部。

``` cl eval-region
(define-key emacs-lisp-mode-map (kbd "C-x C-r") 'eval-region)
(define-key lisp-interaction-mode-map (kbd "C-x C-r") 'eval-region)
```

然后，我们选择一个区域后，就可以用`C-x C-r`来eval一个选区了。

### 加速打开Emacs：Daemon ###

Emacs使用Client/Server可以大大提高新Emacs的开启速度，所有的client共用server来处理数据。

#### 先启动Server ####

首先添加一个开机启动，这个会启动一个Emacs Daemon进程。可以让其他emacsclient连接到server来编辑。

`emacs --daemon`

#### Client ####

##### Terminal #####

编辑~/.bashrc，加上

``` bash
alias ec='emacsclient -t -a=""'
alias se='SUDO_EDITOR="emacsclient -t" sudo -e'
```

然后，就可以通过`ec filename`来用emacs编辑文件。即使是有大量配置文件，开启速度也绝对不亚于Vim。因为client不加载任何配置，只是直接连到server。

##### Desktop #####

修改快捷方式的的command为

``` bash
emacsclient -c -a=""
```

不过，我觉得Desktop的Emacs不需要连接Daemon，因为Desktop的Emacs只需要开一次就好了。Daemon会有一些奇葩的问题，例如session似乎就没法保存。

使用Daemon主要是为了提高开启速度，这个在Terminal中经常开关Emacs编辑文件时就很重要。而在Desktop就开一次的情况就显得没什么了。

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


### 更多效率插件 ###

#### Helm

Helm可以方便地帮助我们找到想要的buffer、文件。而且看上去也很酷。

{% img /imgs/snapshot23_20130227_104506_4247DHx.png %}

#### smex

smex提供了更好的M-x体验。它让M-x变成了像ido一样，可以实时提供补全。让M-x更加快速。

{% img /imgs/snapshot24_20130227_104955_42471QA.png %}

#### session

配合desktop可以保存我们上一次的工作状态。也就是重新打开Emacs的时候，会变成上次关闭的状态。当然也可以[分项目保存不同的session](http://everet.org/emacs-project-manager.html)，这样就和IDE保存工作区一样了。

#### undo-tree ####

Emacs的undo非常诡异，只有undo，没有redo。如果要redo，那只有undo undo。

不过这样的设计，让Emacs的撤销变得异常强大。Emacs可以帮你所有的修改记录都保存下来，我们可以肆意地修改、undo完修改，各种修改，我们都可以回到曾经的状态。这个是其他编辑器难以做到的。

undo-tree可以将所有的状态用树状结构绘制出来。然后我们轻松地可以找到我们需要的状态，甚至可以diff不同的状态。

我们按`C-x u`可以进入undo-tree-visualizer-mode, 然后 `p`、`n` 上下移动，在分支之前 `b`、`f` 左右切换，`t` 显示时间戳，`d` 打开diff，选定需要的状态后，`q` 退出。这是主要的操作，其它的自己摸索好了…… [^10]

{% img /imgs/QQ20140820-7_20140820_231214_35033CkM.png 540 %}

#### 更多
Emacs中还有很多很多非常有用的插件，我这里有[一些](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-el-get-settings.el)我在用的。

Minimap， 这个也是Sublime Text中另一个经常被提起的特性，Emacs装一个[minimap](https://github.com/dustinlacewell/emacs-minimap)也即可拥有。不过说实话，这个功能感觉貌似没啥意义。

{% img /imgs/QQ20140821-1_20140821_000243_35033PuS.png 600 %}

还有些比较好用的：

1. [anzu](https://github.com/syohex/emacs-anzu)，这个让搜索、替换变得更友好。
1. [helm-swoop](https://github.com/ShingoFukuyama/helm-swoop)，直观方便。
1. ag，比ack更快的搜索工具。
1. goto-last-change，快速切换到上一个编辑的位置。
1. [org-mode](http://orgmode.org/)，这个不用说，Emacs中超强大的文本编辑mode，编辑完可以导出各种格式例如pdf、html、word等。我的毕业论文和平时很多东西都是用org-mode写的。我也用org-mode写些[wiki](http://everet.org/notes/)。

## 0x06 UI定制

Emacs的默认界面，见文章第一张图，看起来非常挫。不过幸运的是，Emacs具有超强的可定制性，于是我们可以随心所欲地调整UI。

### 标题栏
就可以显示当前项目名，当前编辑文件的完整路径。

``` cl
(setq frame-title-format
      (list "[" '(:eval (projectile-project-name)) "]"
	    " ψωETωψ ◎ "
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
```

### 顶部tab栏

这个需要装一个叫做tabbar的插件，装完后，就有了顶部的tab栏。具体颜色和形状的配置可以围观：[my-tabbar.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-tabbar.el)。

{% img /imgs/QQ20140821-3_20140821_230929_62337yfP.png %}

### 左边的行号

没错，不像Vim里面直接`set nu`就可以开启行号，Emacs的行号还需要装个插件来实现。不过庆幸的是，Emacs 22之后都自带了linum插件，只要启用就可以有行号了。

``` cl
(require 'linum)
(global-linum-mode t)
```

### 底部的mode-line

底部的一条显示了很多信息的东西叫做mode-line。默认的非常简单，我们可以对其进行定制。如果比较懒，可以直接用[emacs-powerline](https://github.com/jonathanchu/emacs-powerline)插件就可以有一个漂亮的powerline。

{% img /imgs/powerline_20140821_002729_35033c4Y.png %}

不过我还是比较喜欢自己定制。

{% img /imgs/QQ20140821-2_20140821_002921_35033pCf.png %}

依次显示文件名、当前编辑状态、滚动进度，当前mode，使用何种版本控制以及分支，最后是当前时间。

具体可以围观：[my-ui.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-ui.el)，里面有详细的配置。


## 0x07 eshell ##

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


## 0x08 TRAMP ##

TRAMP的全写为：Transparent Remote (file) Access, Multiple Protocol。在TRAMP的帮助下，我们可以很容易做到无缝编辑远程文件。

详细阅读：[Emacs Tramp 详解](http://blog.donews.com/pluskid/archive/2006/05/06/858306.aspx)

## 0x09 文件管理dired ##

dired是Emacs自带的文件管理系统，能够和Tramp无缝配合使用。

{% img /imgs/snapshot20_20130210_125016_1347768h.png %}

默认的dired看上去显示太多东西了，我们可以通过dired的扩展来定制我们需要显示的东西。

我们用el-get很容易就安装好dired扩展"dired-details"和"dired-details+"。然后就可以定制dired显示内容了。默认会隐藏掉不那么常用的信息。如下：

{% img /imgs/snapshot19_20130210_125029_13477HHo.png %}

当按下`)`就可以显示详细信息了。

dired最强大之处，在于可以直接修改这个buffer里面的内容就可以直接对文件进行修改了，就可以很方便地批量重命名。我们按`C-x C-q`(dired-toggle-read-only)进入`Wdired mode`编辑模式，然后就可以像平时编辑文本一样编辑这个buffer，当完成后按`C-c C-c`(wdired-finish-edit)保存到磁盘，就可以完成批量修改文件名了。

## 0x0A 调试Emacs扩展 ##

有时候Emacs的插件会出现各种问题，我们就需要进行调试了。

如果我们希望在出现错误的时候能够自动进入调试模式，那我们可以`M-x toggle-debug-on-error`。

如果有时候Emacs卡住没有反应，但是按`C-g`能够恢复的话，那说明可能是进入了死循环。我们可以在之前打开`M-x toggle-debug-on-quit`，然后在我们按`C-g`的时候就可以调试当前正在运行的elisp。

那有时候我们需要在某个elisp函数设置断点的话，我们可以通过`M-x debug-on-entry [funcname]`来为某个函数设置断点。取消断点可以通过`M-x cancel-debug-on-entry`。

在我们进入调试模式的时候，按`d`可以单步，`q`退出，`e`执行lisp。

详细：[Debugger Commands](http://www.gnu.org/software/emacs/manual/html_node/elisp/Debugger-Commands.html)


## 0x0B Development ##

### autocomplete ###

autocomplete[^9]可以为我们提供类似常用IDE一样的弹出式提示。而补全来源也可以轻松的自定义，是一个非常好的补全框架。

{% img /imgs/snapshot22_20130217_114849_2411dZJ.png %}

### Yasnippet ###

Yasnippet是一个非常强大的模板替换扩展，可以轻松自己定制模板，而且模板还可以嵌入lisp进行逻辑处理，非常强大。

可以围观视频：[Emacs Rocks! Episode 06: Yeah! Snippets!](http://emacsrocks.com/e06.html)

### Python ###

作为一个Python程序员，拥有一个好用的Python开发环境是非常的重要的。

相信大家在网上找到的Emacs Python IDE搭建靠的都是PyMacs和Rope。Rope是一个很强的库，不仅可以用来补全，还可以用来重构等等。

不过Rope的补全速度有些缓慢，于是我们可以求助一个更强更迅速的补全库jedi[^5]，这是一个异步的补全库，不会阻塞编辑。而且jedi已经对autocomplete有很好的兼容了。安装仅需要`M-x el-get-install jedi`。

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

### 其他开发辅助插件 ###

像Emacs中的开发辅助插件还有很多，比较重型的有cedet(Collection of Emacs Development Environment Tools)、ecb(Emacs Code Browser)等等，都是有效的工具，可以帮助我们提高工作效率。另外还有挺多小工具。

1. [magit](https://github.com/magit/magit)，在Emacs中方便友好地使用git。
1. [git-gutter](https://github.com/syohex/emacs-git-gutter)可以实时显示当前文件的diff。而且可以快速跳到相对于上一次commit修改的部分。
1. [projectile](https://github.com/bbatsov/projectile)，超好用的项目辅助工具，可以快速在当前项目搜索、打开文件、编译等等。
1. emacs-helm-gtags[^15]，可以配合gtags快速跳转到定义等。
1. rainbow-mode，能够把css、html等文件中的颜色直接显示出来。
1. nginx-mode，可以语法高亮nginx的配置文件。
1. httpcode，速查http状态码

像[Git-timemachine](http://everet.org/git-timemachine.html)，可以直接查看文件的不同版本历史：

{% img /imgs/git-timemachine2.gif %}


## 0x0C 更多Emacs的用途

### 编辑Chrome的文本框
对于平时的生活，Emacs可以编辑Chrome里面的内容，例如有时需要发段代码：[Chrome Edit With Emacs](http://everet.org/chrome-edit-with-emacs.html)。

### 写Markdown

对于用Markdown写Blog，Emacs甚至可以直接截图、插入图片：[Screenshot and Image Paste in Emacs When Writing Markdown](http://everet.org/screenshot-and-image-paste-in-emacs-when-writing-markdown.html)。

插入完图片后，可以直接在Emacs中预览Markdown中的图片：[让Emacs显示Markdown中的图片](http://everet.org/emacs-markdown-display-image.html)，这个绝对让其他编辑器望尘莫及。

{% img /imgs/QQ20140820-6_20140820_225855_35033191.png %}

### 字符画

Emacs的`Artist Mode`[^16]可以直接画字符画，按下`M-x artist-mode`就可以用鼠标画字符画图了，

``` text 字符画
   +--------------------------------------------+
   |    +-------+                +--------+     |
   |    |       |                |        |     |
   |    +-------+    -----       +--------+     |
   |.               (     )                   ..|
   |...              -----.                   . |
   +--------------------X-----------------------+
               ----/   / \        \-----
          ----/       /  |              \---
       --/           /    \
                   -/      \
                  /         \
                 /          |
                /            \
```


当然像上个网，煮个咖啡，听个音乐，聊个天，收发个邮件，Emacs都可以轻松做到。

## 0x0D 帮助 ##

如果在使用Emacs的过程中遇到什么问题，可以求助于Emacs强大的帮助系统。

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
当开当前mode的帮助。这里挺详细的对于当前可用快捷键的描述。

### ... C-h
当我们不能完整记得某些快捷键的时候，可以按下前缀后，再按下`C-h`。就可以看到以这个前缀开始的快捷键有哪些。

### C-h a 更模糊的查找
有些时候我们只知道一个关键字，这个时候可以用 `C-h a` 来通过正则表达式来查找命令名。Emacs 会列出所有匹配的命令以及一个简短的文档，并可以通过点击链接定位到该命令的详细文档。

### 请个快捷键导师

Emacs中有个快捷键导师，可以在你需要的时候，提示你，可以围观：[Emacs中的快捷键导师](http://everet.org/guide-key.html)

## 0x0E Misc ##

### 一些有趣的快捷键 ###

- `C-M-h` 标记一个函数定义
- `C-h C-a` about-emacs
- `C-h C` 查看当前文件的编码
- `C-u M-! date` 插入当前时间
- `C-u M-=` 计算整个缓冲区的行数、字数和单词数
- `C-x <RET> f utf-8` （set-buffer-file-coding-system），设置当前buffer的文件的编码
- `C-x C-+` and `C-x C--` to increase or decrease the buffer text font size
- `C-x C-q` 开关read-only-mode，在dired-mode中可以进入修改模式，可以批量修改文件名。
- `C-x C-t` 交换两行。可以用来调整python中import
- `M-x sort-lines` 排序选中行。
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
- `M-x list-colors-display` 显示Emacs所有的颜色，方便我们来进行配色

当然还有很多很多，就不再列了。

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

``` cl
;; http://ergoemacs.org/emacs/emacs_byte_compile.html
(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

(add-hook 'after-save-hook 'byte-compile-current-buffer)
```


## 0x0F 终 ##

写了好<del>几天</del>(一年多了)，发现还有挺多东西没写的，Emacs博大精深，还需要自己慢慢摸索。这里纯当为我的记忆做个快照，让以后的我可以看到在2013年初时，Emacs在我眼中的形象。

如果你阅读到了这里，非常感谢你的耐心，感谢你看完了我如此长篇的唠叨。祝你在2013年效率大大提高～

如果你有兴趣，可以浏览一下[我的Emacs配置文件](https://github.com/cedricporter/vim-emacs-setting/tree/master/emacs)。

最后，我也不想挑起Vim和Emacs无谓的口水战。其实无论是Vim还是Emacs，它的好用程度完全取决于使用者的配置能力，所以好不好用，完全看个人。


## 0x10 有趣的Emacs知识分享

1. <http://whattheemacsd.com/>
1. <http://emacsrocks.com/>
1. <http://planet.emacsen.org/>
1. <https://github.com/emacs-tw/awesome-emacs>
1. 当然还有我的Blog：<http://everet.org/tag/emacs/>


## 0x11 Update

### 2013-02-09
第一版。

### 2014-08-20

更新字节码编译 [diff](https://github.com/cedricporter/cedricporter.github.com/compare/420ca14...6ac5042)

### 2014-08-21

更新大量新内容 [diff](https://github.com/cedricporter/cedricporter.github.com/commit/063be891678559cd7e579416ddb7176b777b2c58)


[^1]: <http://zh.wikipedia.org/wiki/HHKB>

[^2]: <https://github.com/dimitri/el-get>

[^3]: <https://github.com/tkf/emacs-jedi>


[^5]: [emacs-jedi](https://github.com/tkf/emacs-jedi)

[^6]: <http://emacswiki.org/emacs/WindMove>

[^7]: <https://github.com/magnars/expand-region.el>

[^8]: <http://www.emacswiki.org/HighlightParentheses>

[^9]: <http://cx4a.org/software/auto-complete/>

[^10]: <http://linuxtoy.org/archives/emacs-undo-tree.html>

[^11]: <http://ergoemacs.org/emacs/emacs_byte_compile.html>

[^12]: <http://www.emacswiki.org/emacs/Evil>

[^13]: <http://www.emacswiki.org/emacs/ElispCookbook#toc39>

[^14]: <https://github.com/syohex/emacs-helm-ag>

[^15]: <https://github.com/syohex/emacs-helm-gtags>

[^16]: <http://www.cinsk.org/emacs/emacs-artist.html>
