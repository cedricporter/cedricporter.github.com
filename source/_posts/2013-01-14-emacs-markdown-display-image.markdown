---
layout: post
title: "让Emacs显示Markdown中的图片"
date: 2013-01-14 23:36
comments: true
categories: IT
tags: [Emacs, Lisp, Octopress]
---
用Octopress或者直接用Jekyll都会涉及到Markdown。我们在写Markdown的时候，会遇到插入截图或者本地图片的问题。如果我们自己手工写上图片的标记，会非常的麻烦，于是我在前文 [在Emacs中插入截图或者本地图片](http://everet.org/2012/12/screenshot-and-image-paste-in-emacs-when-writing-markdown.html ) 中讲述如何自动化插入图片，来解决插入的问题。

今天我们来看一下如何在Emacs中预览Markdown中的图片。

<!-- more -->

虽然我们已经解决了插入图片不便，但我们有时看到这一串一串的文本图片标记或许有些许蛋疼，于是想预览一下图片，此时又是Emacs展示其强大的时候了。

Emacs中有`iimage-mode`可以方便地让我们显示图片，是Emacs自带的。当然如果想在buffer中插入图片我们甚至可以直接调用`insert-image` [^1]往buffer中插入图片。我想Vim里面如果要显示图片一定相当相当蛋疼吧，哈哈。Emacs用户真幸福。

## 实现
好，又到了动手的时候了，让我们卷起袖子准备开工！

``` cl iimage settings https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-iimage-settings.el my-iimage-settings.el
;; {% raw %}
(require 'iimage)

(add-hook 'info-mode-hook 'iimage-mode)
(add-hook 'markdown-mode-hook '(lambda()
				 (define-key markdown-mode-map
				   (kbd "<f12>") 'turn-on-iimage-mode)))

(setq iimage-mode-image-search-path '(list "." ".."))

;; for octopress
(add-to-list 'iimage-mode-image-regex-alist ; match: {% img xxx %}
	     (cons (concat "{% img /?\\("
			   iimage-mode-image-filename-regex
			   "\\) %}") 1))
(add-to-list 'iimage-mode-image-regex-alist ; match: ![xxx](/xxx)
	     (cons (concat "!\\[.*?\\](/\\("
			   iimage-mode-image-filename-regex
			   "\\))") 1))
;; 兼容以前在wordpress添加的图片
(add-to-list 'iimage-mode-image-regex-alist ; match: ![xxx](http://everet.org/xxx)
	     (cons (concat "!\\[.*?\\](http://everet.org/\\(wp-content/"
			   iimage-mode-image-filename-regex
			   "\\))") 1))
;; {% endraw %}
```

我们首先设置一下图片搜索路径`iimage-mode-image-search-path`，可以根据实际需要进行设置。对于Octopress的目录结构，我将其设置为当前以及上一级目录`(list "." "..")`。

然后，我们来设置图片的正则表达式，iimage会将文本中满足的正则表达式提取出来替换成图片。对于插入到`iimage-mode-image-regex-alist`中的正则表达式，为一个点对`(REGEXP . NUM)`。为什么是这样呢？因为正则表达式中可能会有很多级的括号，通过`NUM`我们可以指定取哪一个group的内容为图片路径，像NUM为0的时候取得是整个表达式的值，这个有疑问的话可以问一下Google大神。

最后，我们设置在`markdown-mode`中`F12`为开关图片显示。

## 效果

{% img /imgs/snapshot7_20130115_000417_4317rhI.png %}

详细配置可以看[my-iimage-settings.el](https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-iimage-settings.el)。

[^1]: [Showing Images](http://www.gnu.org/software/emacs/manual/html_node/elisp/Showing-Images.html)
