---
comments: true
date: 2012-04-24 20:06:02
layout: post
slug: linear-equations-solvers-in-python
title: Python的“黑暗魔法”，两行解一元一次方程
wordpress_id: 935
categories:
- 技术类
tags:
- Python
---

无意看到一个大神写的《[Linear equations solver in 3 lines (Python recipe)](http://code.activestate.com/recipes/365013-linear-equations-solver-in-3-lines/)》，Python解一元一次方程只需要三行就完成了，确实很强悍啊。

我们来围观一下：
[![](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-24-195023.png)](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-24-195023.png)

{% codeblock %}
说到底呢，这个段代码的关键是利用了复数。
第一步：
2 * x + 233 = x * 8 + 3
变成
2 * x + 233 -(x * 8 + 3)
然后把x变成虚数1j
然后变成
2 * 1j + 233 -(1j * 8 + 3)
通过eval算出结果为230-6j
因为我们知道这个表达式结果为0，而且j也相当于x。
所以问题变成了：230-6j=0，也就是230-6x=0。
最后x = - 230 / 6 = 38.33333333336。
{% endcodeblock %}

<!-- more -->

{% codeblock %}

{% endcodeblock %}

这里的核心是用到了Python的黑暗魔法eval，eval的第一个参数是表达式，第二个参数是命名空间，也就是把 x = 1j 通过第二个参数把一些值放进去。

[![](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-24-200440.png)](http://everet.org/wp-content/uploads/2012/04/Screenshot-at-2012-04-24-200440.png)

神奇的求解函数：


{% codeblock python lang:python %}

def s(eq, var='x'):
    r = eval(eq.replace('=', '-(') + ')', {var:1j})
    return -r.real / r.imag

{% endcodeblock %}

