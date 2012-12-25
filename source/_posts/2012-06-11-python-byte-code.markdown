---
comments: true
date: 2012-06-11 23:07:07
layout: post
slug: python-byte-code
title: 查看Python字节码
wordpress_id: 1143
categories:
- 我的代码
tags:
- Python
---

有时候我们想看一下Python翻译出来的字节码是怎样的，此时我们可以借助dis模块。

我们在交互式环境iPython下，可以动态地获取我们刚刚创建的函数的字节码。

{% codeblock python lang:python %}
In [1]: import dis

In [2]: def say_hello():
   ...:     print 'Hello, ET'
   ...:     

In [3]: dis.dis(say_hello)
  2           0 LOAD_CONST               1 ('Hello, ET')
              3 PRINT_ITEM
              4 PRINT_NEWLINE
              5 LOAD_CONST               0 (None)
              8 RETURN_VALUE        

In [4]: say_hello()
Hello, ET
{% endcodeblock %}

而对于文件的字节码，我们可以先读取然后编译。<!-- more -->

{% codeblock python lang:python %}

In [2]: s = open('test.py').read()

In [3]: co = compile(s, 'file test.py', 'exec')

In [4]: dis.dis(co)
  1           0 LOAD_CONST               0 (code object say_hello at 0x29a2bb0, 
                                             file "file test.py", line 1)
              3 MAKE_FUNCTION            0
              6 STORE_NAME               0 (say_hello)

  4           9 LOAD_NAME                0 (say_hello)
             12 CALL_FUNCTION            0
             15 POP_TOP             
             16 LOAD_CONST               1 (None)
             19 RETURN_VALUE        


{% endcodeblock %}

其中，dis的输出为：

{% codeblock %}
行号            字节码偏移量     字节码指令        指令参数          对于参数的相关说明
   1             0            LOAD_CONST        1               ('Hello, ET')
{% endcodeblock %}

对于dis模块的介绍，我们可以围观 [http://docs.python.org/library/dis.html](http://docs.python.org/library/dis.html)。

字节码的定义在opcode.h中。


## 参考：





	
  1. 《Python源码剖析》


