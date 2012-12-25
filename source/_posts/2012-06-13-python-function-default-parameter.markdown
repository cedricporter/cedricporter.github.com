---
comments: true
date: 2012-06-13 21:10:31
layout: post
slug: python-function-default-parameter
title: 谈谈Python函数的默认参数
wordpress_id: 1234
categories:
- 我的代码
tags:
- Python
---

Python中很奇葩的一个地方是它的函数的默认参数的值，仅仅在def语句执行的时候计算一次。这会导致什么问题呢？


## 奇葩的例子


我们来看一个例子：<!-- more -->

{% codeblock python lang:python %}
In [44]: def packitem(item, pkg = []):
   ....:         pkg.append(item)
   ....:         return pkg

In [45]: l = [100,200]

In [46]: packitem(300, l)
Out[46]: [100, 200, 300]

In [47]: packitem(1)
Out[47]: [1]

In [48]: packitem(2)
Out[48]: [1, 2]

In [49]: packitem(3)
Out[49]: [1, 2, 3]
{% endcodeblock %}

这个可以看到packitem的默认参数pkg=[]仅仅计算了一次。而之后的packitem函数调用时，pkg都指向了最初创建的那个列表。


## 为什么


为什么会这样呢？

我们此时需要从Python编译出来的字节码中寻求答案。

{% codeblock python lang:python %}
In [65]: def main():
   ....:         def packitem(item, pkg = []):
   ....:                 pkg.append(item)
   ....:                 return pkg
   ....:         print packitem(1)
   ....:         print packitem(2)
   ....:         print packitem(3)    

In [66]: main()
[1]
[1, 2]
[1, 2, 3]

In [67]: dis.dis(main)
  2           0 BUILD_LIST               0
              3 LOAD_CONST               1 (code object)
              6 MAKE_FUNCTION            1
              9 STORE_FAST               0 (packitem)

  5          12 LOAD_FAST                0 (packitem)
             15 LOAD_CONST               2 (1)
             18 CALL_FUNCTION            1
             21 PRINT_ITEM
             22 PRINT_NEWLINE       

  6          23 LOAD_FAST                0 (packitem)
             26 LOAD_CONST               3 (2)
             29 CALL_FUNCTION            1
             32 PRINT_ITEM
             33 PRINT_NEWLINE       

  7          34 LOAD_FAST                0 (packitem)
             37 LOAD_CONST               4 (3)
             40 CALL_FUNCTION            1
             43 PRINT_ITEM
             44 PRINT_NEWLINE
             45 LOAD_CONST               0 (None)
             48 RETURN_VALUE
{% endcodeblock %}

可以看出。packitem函数的默认参数pkg的值是在第一条字节码创建的。随后在MAKE_FUNCTION指令的时候一起和code object打包成一个函数对象，然后通过STORE_FAST 0存在了FAST表的第0位。

后续的函数调用通过LOAD_FAST 0指令将packitem的函数对象取出，然后通过CALL_FUNCTION调用(对于CALL_FUNCTION，我们会在后续的文章进行探讨)。整个函数调用的过程并没有涉及到默认参数值的初始化。

所以，可见，Python函数的默认参数的值仅在函数定义的时候计算，后续的函数调用时的默认参数都是引用最初创建的那个对象。


## Hack It


既然Python没有在我们进行函数调用的时候帮我们重新创建的默认参数的值，那我们就自己动手，丰衣足食。

第一种方案是是用不可变的默认值，例如None，然后在函数内部进行判断。此法略显麻烦。

第二种方案是通过装饰器来解决这个问题。

这段脚本是Sean Ross写的，非常感谢他。

{% codeblock python lang:python %}
In [74]: def freshdefaults(f):
   ....:         fdefaults = f.func_defaults
   ....:         def refresher(*args, **kwds):
   ....:                 f.func_defaults = copy.deepcopy(fdefaults)
   ....:                 return f(*args, **kwds)
   ....:         return refresher

In [75]: @freshdefaults
   ....: def packitem(item, pkg = []):
   ....:         pkg.append(item)
   ....:         return pkg

In [76]: l = [100,200]

In [77]: packitem(300, l)
Out[77]: [100, 200, 300]

In [78]: packitem(1)
Out[78]: [1]

In [79]: packitem(2)
Out[79]: [2]

In [80]: packitem(3)
Out[80]: [3]
{% endcodeblock %}

可以看到，packitem的输出符合我们的预期了。我们通过装饰器freshdefault，完成了对于默认参数的更新。packitem的pkg已经在每次调用的时候更新了。

装饰器等价于

{% codeblock python lang:python %}
myfunc = wrapper(myfunc)
{% endcodeblock %}

在此例子中 ，等价于在后面加上了一句

{% codeblock python lang:python %}
packitem = freshdefault(packitem)
{% endcodeblock %}



## 参考





	
  1. Python Cookbook

	
  2. Python源码剖析


(全文完)
