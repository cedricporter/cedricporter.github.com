---
layout: post
title: "Emacs Tips：Python mode的快捷键"
date: 2013-01-30 21:30
comments: true
categories: IT
tags: [Python, Emacs]
---

[Emacs](http://everet.org/tag/emacs/)是最好的Python编辑器之一。Emacs还可以煮咖啡[^1]-_-||

Emacs的python mode能够让编辑Python脚本变得非常得舒服。我们来围观一下Emacs自带的Python mode里面的快捷键：

<!-- more -->

## 执行Python代码

 * `C-c RET`	imports or reloads the file in the Python interpreter
 * `C-c C-c`	把整个buffer的内容发送到python解释器，就相当于运行这个文件。
 * `C-c |` 	把当前选取发送过去
 * `C-M-x` 	发送当前函数定义或者类定义
 * `C-c C-s`	发送任意字符串过去，也就是执行任意Python命令
 * `C-c !`	starts a Python interpreter window; this will be used by subsequent Python execution commands

## 缩进 ##

 * `C-c <tab>`	 根据上下文重新缩进选区
 * `C-c <`	     左移选区
 * `C-c >`	     右移

## 选择 ##

* `M-x py-mark-block`	 选中一个block
* `C-M-h`	 选中函数
* `C-u C-M-h`	 选中类

## 移动 ##

 * `C-M-a`	 移动到函数定义def
 * `C-u C-M-a`	 移动到类定义
 * `C-M-e`	 移动到函数定义结束
 * `C-u C-M-e`	 类定义结束

## Misc ##

 * `C-c ?` 打开python-mode的文档



[^1]: http://www.emacswiki.org/emacs-se/CoffeeMode
