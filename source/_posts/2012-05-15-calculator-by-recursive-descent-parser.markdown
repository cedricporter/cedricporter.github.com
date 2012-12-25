---
comments: true
date: 2012-05-15 22:00:04
layout: post
slug: calculator-by-recursive-descent-parser
title: 用LL(1)递归下降语法器构造一个计算器
wordpress_id: 1062
categories:
- My Code
tags:
- compile
- Python
---

## LL(1)


何为LL(1)？通俗来说就是向前看一个词法单元的自顶向下解析器。两个L都代表left-to-right，第一个L表示解析器按“从左到右”的顺序解析输入内容；第二个L表示下降解析时也是按“从左到右”的顺序遍历子节点。而(1)表示它使用一个向前看 词法单元。

我们从一个简单的计算器来看看递归下降的语法器如何构造。

对于 2 + 3 * 5 的抽象语法树如下：<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-213202.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-213202.png)

我们可以使用如下文法表示计算表达式：

# expr ::= expr addop term | term
# term ::= term mulop factor | factor
# factor ::= number | ( expr )
# addop ::= + | -
# mulop ::= * | /


## 例子


我们用Python构造一个递归下降实现的计算器。


{% codeblock python lang:python %}

#!/usr/bin/env python
# author:  Hua Liang [ Stupid ET ]
# email:   et@everet.org
# website: http://EverET.org
#

# Grammar:
#     expr    ::= expr addop term | term
#     term    ::= term mulop factor | factor
#     factor  ::= number | ( expr )
#     addop   ::= + | -
#     mulop   ::= * | /

import tokenize, StringIO

tokens = None
cur_tok = None

def scan(text):
    g = tokenize.generate_tokens(
        StringIO.StringIO(text).readline)
    return ((v[0], v[1]) for v in g)

def get_token():
    global tokens, cur_tok
    cur_tok = tokens.next()
    #print cur_tok
    return cur_tok

def match(type, val = ''):
    global tokens, cur_tok
    t, v = cur_tok
    if t == type or t == tokenize.OP and v == val:
        get_token()
    else:
        raise

def expr():
    global cur_tok
    tmp = term()
    t, v = cur_tok
    while v == '+' or v == '-':
        match(tokenize.OP)
        rhs = term()
        e = str(tmp) + str(v) + str(rhs)
        tmp = eval(e)
        print e, '=', tmp
        t, v = cur_tok
    return tmp

def term():
    global cur_tok
    tmp = factor()
    t, v = cur_tok
    while v == '*' or v == '/':
        match(tokenize.OP)
        rhs = factor()
        e = str(tmp) + str(v) + str(rhs)
        tmp = eval(e)
        print e, '=', tmp
        t, v = cur_tok
    return tmp

def factor():
    global cur_tok
    t, v = cur_tok
    if t == tokenize.NUMBER:
        match(tokenize.NUMBER)
        return int(v)
    elif v == '(':
        match(tokenize.OP, '(')
        tmp = expr()
        match(tokenize.OP, ')')
        return tmp
    else:
        raise

if __name__ == '__main__':
    text = '12 + 2 * ( 5 + 6 )'
    tokens = scan(text)
    get_token()
    res = expr()
    print text, '=', res


{% endcodeblock %}


对于12 + 2 * ( 5 + 6 )，运行结果如下：
[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-214802.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-15-214802.png)

源码请见：[https://github.com/cedricporter/et-python/blob/master/compilers/func-cal/main.py](https://github.com/cedricporter/et-python/blob/master/compilers/func-cal/main.py)


## 参考


[1] Language Implementation Patterns

[2] Compiling Little Languages in Python

[3] [Python使用spark模块构造计算器](http://everet.org/2012/05/python-spark-calculator.html)
