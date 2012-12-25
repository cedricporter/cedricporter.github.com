---
comments: true
date: 2012-05-15 21:59:07
layout: post
slug: building-recursive-descent-parser
title: 构建LL(1)递归下降语法解析器
wordpress_id: 1056
categories:
- My Code
tags:
- compile
- Python
---

不管什么语言应用，识别语言这一步都很重要。

在小学时，大家都学习过如何分辨句子中的不同语言成分，例如动词和名词等。识别计算机语言也是如此（我们称之为语法分析）。


## 小例子


我们来看一下：


> return x + 1;


语法图：<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-210601.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-210601.png)

解析树：

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-210616.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-210616.png)

树上的叶节点是词法单元，分子节点表示推导式中的子结构。

我们来看一下手工编写语言解析器。

为了验证语句的是否合法，解析器需要识别语句的解析树。但是，解析器不一定在内存中构造这么一个树状结构。一般情况下，我们只需要在遇到子结构时采用适当的操作即可。也就是说，解析器的任务是“遇到某些结构，就执行某些操作”。

为了避免构造解析树，我们通过函数调用序列隐私地得到他们的信息。我们要做的事情就是为每一个子结构构造一个函数。

```
stat  ::= returnstat
returnstat ::= "return" expr ";"
expr ::= "x" "+" "1"
```

构造出来的函数：

```
/** To parse a statement, call stat(); */
void stat()
{ returnstat(); }
void returnstat() { match("return" ); expr(); match(";" ); }
void expr()
{ match("x" ); match("+" ); match("1" ); }
```

如何解析if、return和赋值语句呢？

我们可以将stat实现成这样。

```
void stat() {
 if ( «lookahead token is return » )               returnstat();
 else if ( «lookahead token is identifier » ) assign();
 else if ( «lookahead token is if » )                ifstat();
 else «parse error »
}
```


如果要手写这种解析器，头几个可能挺好玩的，但是这样的活多干几次就会觉得很无聊了。


## 例子

  * [用Python实现的LL(1)递归下降语法器计算器](http://everet.org/2012/05/calculator-by-recursive-descent-parser.html)
  * [Python使用spark模块构造计算器](http://everet.org/2012/05/python-spark-calculator.html)


## 参考

[1] Language Implementation Patterns

[2] Compiling Little Languages in Python
