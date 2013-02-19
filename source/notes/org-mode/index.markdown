---
layout: page
title: "我的Org-Mode笔记"
date: 2013-02-07 23:27
comments: true
sharing: true
footer: true
---

## 文档结构

### 切换可见性

- `<TAB>` (org-cycle)

```
,-> FOLDED -> CHILDREN -> SUBTREE --.
'-----------------------------------'
```
- `S-<TAB>` (org-global-cycle)
- `C-u <TAB>`

```
,-> OVERVIEW -> CONTENTS -> SHOW ALL --.

```
- `C-u C-u C-u <TAB>` (show-all)
- `C-c C-k` (show-branches)
- `C-c C-x v` (org-copy-visible)
- 其他

> When Emacs first visits an Org file, the global state is set to
> OVERVIEW, i.e. only the top level headlines are visible.	This can be
> configured through the variable `org-startup-folded', or on a per-file
> basis by adding one of the following lines anywhere in the buffer:

```
#+STARTUP: overview
#+STARTUP: content
#+STARTUP: showall
#+STARTUP: showeverything
```

### 移动

- `C-c C-n` Next heading
- `C-c C-p` Previous heading
- `C-c C-f` Next heading same level，下一个同级标题
- `C-c C-b` Previous heading same level
- `C-c C-u` Backward to higher level heading，回到更高级的标题
- `C-c C-j` Jump to a different place


### 编辑文档结构

- `<TAB>` demote entry and back to initial level
- `C-<RET>` Just like `M-<RET>', except when adding a new heading below the
current heading, the new heading is placed after the body instead
of before it.
- `C-c `* Turn a normal line into a headline.
- `C-c ^` Sort same-level entries.
- `C-c C-x C-w` Kill subtree
- `C-c C-x C-y` Yank subtree
- `C-c C-x M-w` Copy subtree
- `C-S-<RET>` Insert new TODO. Like `C-<RET>`
- `M-<left>` Promote heading
- `M-<RET>` Insert new heading with same level as current
- `M-<right>` Demote heading
- `M-S-<down>` Move subtree down
- `M-S-<left>` Promote subtree
- `M-S-<RET>` Insert new TODO with same level as current heading.
- `M-S-<right>` Demote subtree
- `M-S-<up>` Move subtree up


### Sparse trees

- `C-c / r` Prompts for a regexp and show a sparse tree with all matches. Highlight disappear when edit or press C-c C-c.
- `M-g n` or `M-g M-n` Jump to the next sparse tree


### Plain lists

- `C-c -` 切换列表项的前缀类型（- + * 1. 1)）
- `C-c C-`* 将列表变成当前headline
- `C-c C-c` toggle the state of the checkbox.
- `M-<up>` Move the item including subitems up.
- `M-S-<RET>` Insert a new item with a checkboxes
- `S-<left>` 切换列表项的前缀类型
- `S-<up>` Jump to the previous item in the current list.


### Drawers

- `C-c C-z` 添加一个有时间的笔记
- Note taken on [2012-12-20 Thu 16:21] \\ I don't know what is this.


### Footnotes

```
The Org homepage[fn:1] now looks a lot better than it used to.
...
[fn:1] The link is: http://orgmode.org
```

- `C-c C-x f` 创建脚注或者跟随脚注跳转
- `C-u C-x C-x f` 调整脚注
- `C-c C-c` 跳转
- `C-c C-o` 跳转

## Markup

### 结构化标记元素

### 文档标题
导出的时候会用到。

```
#+TITLE: This is the title of the document
```

### 目录
目录会自动插入到最前面。可以定制：

```
#+OPTIONS: toc:2          (only to two levels in TOC)
#+OPTIONS: toc:nil        (no TOC at all)
```

### 在第一个headline前的文本
如果需要在最前面加上什么东西，可以通过#+TEXT构造：

```
#+OPTIONS: skip:t
#+TEXT: This text will go before the *first* headline.
#+TEXT: [TABLE-OF-CONTENTS]
#+TEXT: This goes between the table of contents and the *first* headline
```

### 强调以及等宽字体

```
*bold*, /italic/ _underlined_ =code= ~verbatim~ +strike-through+
```

## Miscellaneous

### 模板
要插入模板可以先输入一个“<”，然后加上seletor：

```
`s'     `#+begin_src     ... #+end_src'
`e'     `#+begin_example ... #+end_example'
`q'     `#+begin_quote   ... #+end_quote'
`v'     `#+begin_verse   ... #+end_verse'
`c'     `#+begin_center  ... #+end_center'
`l'     `#+begin_latex   ... #+end_latex'
`L'     `#+latex:'
`h'     `#+begin_html    ... #+end_html'
`H'     `#+html:'
`a'     `#+begin_ascii   ... #+end_ascii'
`A'     `#+ascii:'
`i'     `#+index:' line
`I'     `#+include:' line
```

### 多用途的C-c C-c

- 关闭高亮
- 重新对齐表格
- 对表格应用公式
- 跳到footnote的另一边
- 勾选checkbox
- 给有序列表重新编号


### 编辑block

`C-c '`可以根据模式来编辑。

## Export

### Export Options
<http://orgmode.org/manual/Export-options.html#Export-options>

------
