---
layout: post
title: "Screenshot And Image Paste in Emacs When Writing Markdown"
date: 2012-12-28 03:36
comments: true
categories: [IT, My Code]
tags: [Lisp, Markdown, Emacs]
---

Octopress首选博客语言是Markdown。于是又是Emacs大显身手的时候了。

在用Markdown写东西的时候，我想最蛋疼的应该就是插入图片了。

正常的插入截图的步骤可能为：

1. 打开截图程序截图
1. 保存截图到Octopress的制定目录中
1. 然后在Markdown中写上图片的url的地址

这样一次两次还可以接受，如果长期这样是在让人受不了。对于我这种懒人，首先就要偷懒，让Emacs帮我们做这些事情。

## 功能演示

### 截图
我们按下`C-c` `C-s` `s`就开始截图了，截完图后，会自动保存到我们指定的目录，例如我的是`~/octopress/source/imgs/`。

下面这张图是用Emacs截图自动插入的：
{% img /imgs/2012-12-28-screenshot-and-image-paste-in-emacs-when-use-markdown.markdown_20121228_021049_6910Rbg.png %}
用起来感觉很爽，按下快捷键，一截图，唰一下就出来一段代码。

<!-- more -->

### 插入本地图片
对于本地硬盘里面的图片的插入，我们可以先在文件浏览器（例如Dolphin）中选中要插入的图片，然后复制图片。回到Emacs中，按下`C-c` `C-s` `i`插入我们的图片。

这里会发生什么事情呢？我很无聊地让Emacs将图片复制到`~/octopress/source/imgs/`中，然后插入图片在url中地址。

下面是自动插入的图片。
{% img right /imgs/emacs_20121228_015008_69103GU.jpg %}

> What Emacs does to your keyboard?[^1]


## 实现
上面都是在介绍功能，现在我们来看一下如何实现。

其实也就是写Emacs Lisp。我自从实习回来就基本没怎么写过代码了，今天难得写一下Lisp，顿时觉得神清气爽啊-_-||。

我们可以看到第一张截图，默认插入的图片格式是`{% raw %} {% img url %} {% endraw %}`，这个是Octopress的Tag，可以方便地定制图片的样式。如果需要插入Markdown格式的图片，可以加上前缀`C-u`，也就是命令变成`C-u` `C-c` `C-s` `s`这样。这个快捷键绑定略显麻烦，大家可以自己自己绑定到喜欢的快捷键上。

首先我们需要设置Octopress的信息，包括本地的图片路径，以及在网络上的图片路径：

``` cl
(setq octopress-image-dir (expand-file-name "~/octopress/source/imgs/"))
(setq octopress-image-url "/imgs/")
```

然后开始写程序：

首先是截图，这个直接在网上找到了实现[^2]，然后根据需求进行修改：

``` cl
;; {% raw %}
(defun my-screenshot (dir_path)
  "Take a screenshot and save it to dir_path path.
Return image filename without path so that you can concat with your
opinion. "
  (interactive)
  (let* ((full-file-name
	  (concat (make-temp-name (concat dir_path (buffer-name) "_" (format-time-string "%Y%m%d_%H%M%S_"))) ".png"))
	 (file-name (my-base-name full-file-name))
	 )
    (call-process-shell-command "scrot" nil nil nil (concat "-s " "\"" full-file-name "\""))
    file-name
    ))

;; Screenshot
(defun markdown-screenshot (arg)
  "Take a screenshot for Octopress"
  (interactive "P")
  (let* ((dir_path octopress-image-dir)
	 (url (concat octopress-image-url (my-screenshot dir_path))))
    (if arg
	(insert "![](" url ")")
      (insert "{% img " url " %}"))))
;; {% endraw %}
```

然后是从剪切版Clipboard插入图片，这个找不到，于是只能自己写了哎。Lisp水平太差，写了好久...囧。

``` cl
;; {% raw %}
;; base on http://emacswiki.org/emacs/CopyAndPaste
(defun get-clipboard-contents-as-string ()
    "Return the value of the clipboard contents as a string."
    (let ((x-select-enable-clipboard t))
      (or (x-cut-buffer-or-selection-value)
          x-last-selected-text-clipboard)))

(defun copy-file-from-clipboard-to-path (dst-dir)
  "copy file to desired path from clipboard"
  (interactive)
  (let* ((full-file-name) (file-name) (ext) (new-file-name))
    (setq full-file-name (get-clipboard-contents-as-string))
    (if (eq (search "file://" full-file-name) 0)
	(progn
	  (setq full-file-name (substring full-file-name 7))
	  (setq file-name (my-base-name full-file-name))
	  (setq ext (concat "." (file-name-extension file-name)))
	  (setq new-file-name
		(concat (make-temp-name
			 (concat (substring file-name 0
					    (search "." file-name :from-end t))
				 (format-time-string "_%Y%m%d_%H%M%S_"))) ext))
	  (setq new-full-file-name (concat dst-dir new-file-name))
	  (copy-file full-file-name new-full-file-name)
	  new-file-name
	  )
      )))

;; Insert Image From Clip Board
(defun markdown-insert-image-from-clipboard (arg)
  "Insert an image from clipboard and copy it to disired path"
  (interactive "P")
  (let ((url (concat octopress-image-url (copy-file-from-clipboard-to-path octopress-image-dir))))
    (if arg
	(insert "![](" url ")")
      (insert "{% img " url " %}"))))
;; {% endraw %}
```

最后就是设置按键绑定了：

``` cl
(define-key markdown-mode-map (kbd "C-c C-s s") 'markdown-screenshot)
(define-key markdown-mode-map (kbd "C-c C-s i") 'markdown-insert-image-from-clipboard)
```

所有代码请见以下两个文件：[^3]

 * [my-functions.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-functions.el)
 * [my-octopress-settings.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-octopress-settings.el)

## 终
经过九九八十一式终于打完收工，现在又凌晨3点多了。想起我们的[冯华君](http://huajun.w18.net/)师兄，31岁就收到乔布斯的Offer Letter去找教主了，我不禁心里怕怕的，还是早点休息吧。身体是革命的本钱啊。



[^1]: <http://jbarillari.blogspot.com/2010/07/what-emacs-does-to-your-keyboard.html>
[^2]: <http://lists.gnu.org/archive/html/emacs-orgmode/2011-07/msg01292.html> <http://dreamrunner.org/wiki/public_html/Emacs/org-mode.html>
[^3]: [我的Emacs配置文件](https://github.com/cedricporter/vim-emacs-setting)
