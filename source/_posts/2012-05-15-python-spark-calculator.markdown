---
comments: true
date: 2012-05-15 22:24:58
layout: post
slug: python-spark-calculator
title: Python使用spark模块构造计算器
wordpress_id: 1076
categories:
- 我的代码
tags:
- compile
- Python
---

## Spark简介


Spark 解析器与 EBNF 语法有一些共同之处，但它将解析／处理过程分成了比传统的 EBNF 语法所允许的更小的组件。Spark 的优点在于，它对整个过程中每一步操作的控制都进行了微调，还提供了将定制代码插入到过程中的能力。

Spark的最新版是10年前发布的，真是非常的长寿，可见设计精良。其中的采用的设计模式有Reflection Pattern、Visitor Pattern、Pipes and Filters Pattern和Strategy Pattern。


## 初识Spark


第一次知道Spark这个模块是在IBM的网站[[3]](http://everet.org/2012/05/python-spark-calculator.html#reference-everet-3)上看到的。

第一次激起我学习这个模块的兴趣是在看Python源码的时候，发现Python的编译器是用The Zephyr Abstract Syntax Description Language(Parser/Python.asdl)来定义的语法，然后通过(Parser/asdl.py、Parser/asdl_c.py、Parser/spark.py)根据Parser/Python.asdl生成C语言解析器。其中仅用了1000多行就实现了一个yacc。这个是非常地强大。<!-- more -->


## 计算器


对于计算器的构造，我们在[上文中](http://everet.org/2012/05/calculator-by-recursive-descent-parser.html)使用LL(1)递归下降的方法构造了一个。但是Spark更加强大，Spark是用Earley语法分析算法，能够解析所有的上下文无关文法，这比LL和LR要更强，当然代价是更慢。

我们来看用Spark实现的计算器：


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

from spark import GenericParser, GenericScanner

class Token(object):
    def __init__(self, type, attr=''):
        self.type = type
        self.attr = attr
    def __cmp__(self, o):
        return cmp(self.type, o)
    def __str__(self):
        return self.type
    def __repr__(self):
        return str(self)

class SimpleScanner(GenericScanner, object):
    def __init__(self):
        GenericScanner.__init__(self)

    def tokenize(self, input):
        self.rv = []
        GenericScanner.tokenize(self, input)
        return self.rv

    def t_whitespace(self, s):
        r' \s+ '
        pass

    def t_op(self, s):
        r' \+ | \- | \* | / | \( | \) '
        self.rv.append(Token(type=s))

    def t_number(self, s):
        r' \d+ '
        self.rv.append(Token(type='number', attr=s))

class ExprParser(GenericParser):
    def __init__(self, start='expr'):
        GenericParser.__init__(self, start)

    def p_expr_term_0(self, (lhs, op, rhs)):
        '''
            expr ::= expr addop term
            term ::= term mulop factor
        '''
        return eval(str(lhs) + str(op) + str(rhs))

    def p_expr_term_factor_1(self, (v, )):
        '''
            expr ::= term
            term ::= factor
        '''
        return v

    def p_factor_1(self, (n, )):
        ' factor ::= number '
        return int(n.attr)

    def p_factor_2(self, (_0, expr, _1)):
        ' factor ::= ( expr ) '
        return expr

    def p_addop_mulop(self, (op, )):
        '''
            addop ::= +
            addop ::= -
            mulop ::= *
            mulop ::= /
        '''
        return op

def scan(code):
    scanner = SimpleScanner()
    return scanner.tokenize(code)

def parse(tokens):
    parser = ExprParser()
    return parser.parse(tokens)

if __name__ == '__main__':
    text = ' 7 + (1 + 3) * 5'
    print parse(scan(text))


{% endcodeblock %}


源码请见：[https://github.com/cedricporter/et-python/tree/master/compilers/simple-cal](https://github.com/cedricporter/et-python/tree/master/compilers/simple-cal)


## 参考


[1] Language Implementation Patterns

[2] Compiling Little Languages in Python

[3] [可爱的 Python: 使用 Spark 模块解析](https://www.ibm.com/developerworks/cn/linux/sdk/python/charm-27/)

[4] [用LL(1)递归下降语法器构造一个计算器](http://everet.org/2012/05/calculator-by-recursive-descent-parser.html)
