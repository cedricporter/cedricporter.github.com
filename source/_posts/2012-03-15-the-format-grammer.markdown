---
comments: true
date: 2012-03-15 20:17:39
layout: post
slug: the-format-grammer
title: 神奇的Python:格式化UltraDemo的文法
wordpress_id: 695
categories:
- My Code
tags:
- compile
- Python
- UltraDemo
---

SimpleParse是一款非常简洁的Python解析模板，可以自己定义EBNF文法，然后SimpleParse会输出结构化的。

SimpleParse的介绍可以见，[http://www.ibm.com/developerworks/cn/linux/sdk/python/charm-23/index.html](http://www.ibm.com/developerworks/cn/linux/sdk/python/charm-23/index.html)，我也是从IBM的网站上看到这个神奇的模块的。

我们有如下的UltraDemo的文法，这个是我们之前写在word文档里面的。

他们很乱，于是我们要对其进行格式化。

不幸的是，我们没有现成的工具可以格式化它，所以我们要自己定制一个小工具来完成我们的任务。

此时我们可以借助SimpleParse。

下面的原始的文法，很乱是不是：<!-- more -->


{% codeblock text lang:text %}

Program 			 -> external_declaration
external_declaration-> Func_definitions | external_decl_stmt
Func_definitions	 -> {Func_definition}+
Func_definition	 -> type id “(“ param_type_list “)” block
external_decl_stmt -> <empty> | type declarators “;”
Type 			 -> int | float | double | char | long | ………….
Param_type_list 	 -> type id {type_param}* | <empty>
Type_param		 -> “,” type id | <empty>
Block			 -> “{“ stmts “}”
Stmts        -> decl_stmt | if_stmt | while_stmt | for_stmt | dowhile_stmt |                               switch_stmt | return_stmt | assign | <empty>
Decl_stmt		-> <empty> | type declarators “;”
Declarators		-> declarator { “,” declarator }
Declarator		-> {Pointer}? id { arrayDeclarator}	? assignForDecl
Pointer			-> “*” {pointer}?
arrayDeclarator	-> “[“ {const_expr}? “]” {arrayDeclarator}?
const_expr		-> conditional_expr
conditional_expr	-> logical_expr | logical_expr “?” expr : conditional_expr
assignForDecl		-> <empty> | “=” expr
factor			-> num | “(“ expr “)” | abstract_declarator
abstract_declarator-> id | id “[“ expr “]” | id “(“ param_list “)” | id “->” abstract_declarator
| id “.” abstract_declarator
param_list		-> <empty> | param { “,” param }*
param			-> expr
if_stmt			-> “if” “(“ expr “)” compound_stmt
compound_stmt	-> block | stmt
while_stmt		-> “while” “(“ expr “)” compound_stmt
assign			-> Declarator “=” expr
expr				-> assignment_expr {“,” assignment_expr }+
assignment_expr	-> conditional_expr | unary_expr assgnment_op assignment_expr
assgnment_op	  	-> “=” | “+=” | …
unary_op			-> “&” | “+” | “*” | …
unary_expr		-> postfix_expr | “++” unary_expr | “—“ unary_expr | unary_op cast_expr
cast_expr			-> unary_expr | “(“ type_name “)” cast_expr
postfix_expr		-> primary_expr { postfix_op }+
postfix_op		-> “[“ expr “]” | “(“ assignment_expr “)” | “->” id | “.” Id | “++” | “—“
primary_expr		-> id | constant | string | “(“ expr “)”
constant			-> integer_const | char_const | floating_const | enum_const


{% endcodeblock %}


我们将其格式化后得到：


{% codeblock text lang:text %}


Program               ->  external_declaration
external_declaration  ->  Func_definitions
                       | external_decl_stmt
Func_definitions      ->  {Func_definition}+
Func_definition       ->  type id “(“ param_type_list “)” block
external_decl_stmt    ->  <empty>
                       | type declarators “;”
Type                  ->  int
                       | float
                       | double
                       | char
                       | long
                       | ………….
Param_type_list       ->  type id {type_param}*
                       | <empty>
Type_param            ->  “,” type id
                       | <empty>
Block                 ->  “{“ stmts “}”
Stmts                 ->  decl_stmt
                       | if_stmt
                       | while_stmt
                       | for_stmt
                       | dowhile_stmt
                       | switch_stmt
                       | return_stmt
                       | assign
                       | <empty>
Decl_stmt             ->  <empty>
                       | type declarators “;”
Declarators           ->  declarator { “,” declarator }
Declarator            ->  {Pointer}? id { arrayDeclarator}	? assignForDecl
Pointer               ->  “*” {pointer}?
arrayDeclarator       ->  “[“ {const_expr}? “]” {arrayDeclarator}?
const_expr            ->  conditional_expr
conditional_expr      ->  logical_expr
                       | logical_expr “?” expr : conditional_expr
assignForDecl         ->  <empty>
                       | “=” expr
factor                ->  num
                       | “(“ expr “)”
                       | abstract_declarator
abstract_declarator   ->  id
                       | id “[“ expr “]”
                       | id “(“ param_list “)”
                       | id “->” abstract_declarator
                       | id “.” abstract_declarator
param_list            ->  <empty>
                       | param { “,” param }*
param                 ->  expr
if_stmt               ->  “if” “(“ expr “)” compound_stmt
compound_stmt         ->  block
                       | stmt
while_stmt            ->  “while” “(“ expr “)” compound_stmt
assign                ->  Declarator “=” expr
expr                  ->  assignment_expr {“,” assignment_expr }+
assignment_expr       ->  conditional_expr
                       | unary_expr assgnment_op assignment_expr
assgnment_op          ->  “=”
                       | “+=”
                       | …
unary_op              ->  “&”
                       | “+”
                       | “*”
                       | …
unary_expr            ->  postfix_expr
                       | “++” unary_expr
                       | “—“ unary_expr
                       | unary_op cast_expr
cast_expr             ->  unary_expr
                       | “(“ type_name “)” cast_expr
postfix_expr          ->  primary_expr { postfix_op }+
postfix_op            ->  “[“ expr “]”
                       | “(“ assignment_expr “)”
                       | “->” id
                       | “.” Id
                       | “++”
                       | “—“
primary_expr          ->  id
                       | constant
                       | string
                       | “(“ expr “)”
constant              ->  integer_const
                       | char_const
                       | floating_const
                       | enum_const


{% endcodeblock %}


以下是格式化程序，其中定义了UltraDemo输出文法的EBNF的文法。嗯，对，就是文法的文法，哈哈。

这个写得比较乱，昨晚才接触SimpleParse，还是有些不是很熟悉，有空看看更灵活的Spark。


{% codeblock python lang:python %}

#!/usr/bin/env python
import re
import pprint
from simpleparse.parser import Parser
from simpleparse import dispatchprocessor

declaration = r'''
file            := [ \t\r\n]*, grammer+
grammer         := header, ts, '->', ts, blocks
ts              := [ \t]*
header          := identifier
identifier      := [a-zA-Z_]+
blocks          := block, [\r\n]*, (ts, "|", ts, block, [ \r\n]*)*
block           := -[|\r\n]+
'''

maxTagLen = -1
def counter(tag, start, end):
    '''Find the longest length of header'''
    global maxTagLen
    if tag == 'header' and maxTagLen < end - start:
        maxTagLen = end - start

isFisrtBlock = True
offset = -1
def printer(tag, start, end):
    '''print the grammers'''
    global text, isFisrtBlock, maxTagLen, offset
    if tag == 'header':
        offset = maxTagLen - (end - start)
        print text[start:end],
    elif tag == 'blocks':
        print offset * ' ', '->',
        isFisrtBlock = True
    elif tag == 'block':
        print "%s%s" % ('' if isFisrtBlock else (maxTagLen + 3) * ' ' + '| ', text[start:end])
        isFisrtBlock = False

def travel(root, func):
    if root == None: return

    tag, start, end, children = root
    func(tag, start, end)

    if children != None:
        for item in children: travel(item, func)

if __name__ =="__main__":
    inFile = open("2.txt")
    text = ""
    for line in inFile.readlines():
        text += line + "\n"

    parser = Parser( declaration, "file" )
    success, resultTrees, nextChar = parser.parse(text)
    #pprint.pprint(resultTrees)

    for item in resultTrees: travel(item, counter)
    print maxTagLen
    for item in resultTrees: travel(item, printer)


{% endcodeblock %}

