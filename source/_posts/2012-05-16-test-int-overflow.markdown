---
comments: true
date: 2012-05-16 12:11:42
layout: post
slug: test-int-overflow
title: 判断两个有符号整数相加是否溢出
wordpress_id: 1087
categories:
- IT
tags:
- C++
- Python
---

在Python，默认的整数是long型的，也就是机器字长，32位的最大有符号整数为0x7fffffff，64位最大有符号整数为0x7fffffffffffffff。

而在Python，支持任意大整数的运算，也就是，当我们的long型整数（在Python对象中type为int）溢出的时候，Python会自动将其变成大整数（在Python对象中type为long），也就是和Java中的BigInteger一样，支持任意位数的整数计算，不过更加方便。

我的系统是64位的，最大符号整数为0x7fffffffffffffff，我们来看看两个0x7fffffffffffffff相加会发生什么事情。<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-16-115620.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-16-115620.png)

我们可以看到c的值已经超越C语言中long能够表示的最大整数了，所以Python将其变成了type为long的类型。那么什么时候需要转换呢？

答案是，当溢出的时候。但是我们怎么知道何时溢出？

我们来看一下Python中对于加法的实现。


{% codeblock python lang:python %}

case BINARY_ADD:
    w = POP();
    v = TOP();
    if (PyInt_CheckExact(v) && PyInt_CheckExact(w)) {
        /* INLINE: int + int */
        register long a, b, i;
        a = PyInt_AS_LONG(v);
        b = PyInt_AS_LONG(w);
        /* cast to avoid undefined behaviour
           on overflow */
        i = (long)((unsigned long)a + b);
        if ((i^a) < 0 && (i^b) < 0)
            goto slow_add;
        x = PyInt_FromLong(i);
    }
    else if (PyString_CheckExact(v) &&
             PyString_CheckExact(w)) {
        x = string_concatenate(v, w, f, next_instr);
        /* string_concatenate consumed the ref to v */
        goto skip_decref_vx;
    }
    else {
      slow_add:
        x = PyNumber_Add(v, w);
    }
    Py_DECREF(v);
  skip_decref_vx:
    Py_DECREF(w);
    SET_TOP(x);
    if (x != NULL) continue;
    break;

{% endcodeblock %}


可见，当


> if ((i^a) < 0 && (i^b) < 0) goto slow_add;


为真的时候就是发生溢出了，所以去到了慢速加法通道。
那我们有


> i = a + b


什么时候溢出呢？在a、b都为正数的时候和为负数（正正负）或者a、b都为负数的时候和为正数（负负正）。
所以当 (i^a) < 0 && (i^b) < 0 为 true 的时候溢出了，因为它们的最高位都符合正正负或负负正。
