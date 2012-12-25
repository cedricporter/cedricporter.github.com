---
comments: true
date: 2012-04-18 20:49:32
layout: post
slug: ultrademo
title: UltraDemo —— 数据结构实验平台
wordpress_id: 913
categories:
- My Code
tags:
- C++
- UltraDemo
- DataStructure
---

传统数据结构教学中，老师站在讲台上讲课，放着PPT，而学生坐在下面神游。 原因何在？因为学生缺乏实践机会，所以注意力难以集中。

于是UltraDemo诞生了！ UltraDemo提供一个自己动手实践的平台，我们可以在UltraDemo中编程，并且可以对数据结构可视化。 这个是一个编程实践平台，可以在上面写代码，编译，执行，并且可以查看图形化的数据结构。UltraDemo支持单步执行，支持断点，支持查看当前作用域的变量，支持自动执行，支持自动执行速度选择，支持动画。

UltraDemo已经开源～

源码：[https://github.com/cedricporter/UltraDemo](https://github.com/cedricporter/UltraDemo)


## UltraDemo主要提供以下的功能：


<!-- more -->


## 


1. 用户可以在Ultra Demo中编写类C语言的代码，并编译执行。这使UltraDemo不仅仅是一款演示软件，也是一个非常优秀的实验平台。

2. 用户可为自己编写的代码选择相应的演示动画模块。这样，在代码运行时，用户就可以获得可视化的结果输出。

3. UltraDemo还提供断点调试功能。用户可通过输出窗口和内存窗口监视代码的运行状况。

4. 由于动画模块是以dll插件形式集成到UltraDemo中的，因此高级用户可以根据我们提供的接口，自己编写自己的动画模块。

UltraDemo可将源代码编译产生的中间代码和汇编代码输出供用户学习。


## 运行截图


[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb8.png)](http://everet.org/wp-content/uploads/2012/04/image8.png)

[![Untitled](http://everet.org/wp-content/uploads/2012/04/Untitled_thumb.jpg)](http://everet.org/wp-content/uploads/2012/04/Untitled.jpg)


## 技术架构


UltraDemo主要由三大模块组成，分别是编译解释模块，控制器模块和动画模块。其中编译解释模块以C++编写，控制模块和动画模块在WPF/C#中完成。

[![clip_image002[6]](http://everet.org/wp-content/uploads/2012/04/clip_image0026_thumb.gif)](http://everet.org/wp-content/uploads/2012/04/clip_image0026.gif)


### 编译解释模块：


现有的所有调试器都可分为两大类。第一类调试器利用处理器提供的调试工具，而第二类调试器自行仿真处理器并完全控制所调试程序的执行过程。

因为前者性能低下，所以我们采用后者，仿真处理器进行调试。


### 控制器模块：


其它两个模块将被编译成dll文件，被控制器模块调用。控制器模块负责初始化这两个模块的实例。对于编译解释模块，控制器模块提供解释运行速度的控制，包括断点，单步，暂停等。对于动画模块，控制器模块提供插件扫描和动画帧率控制。值得一提的是，解释运行速度和动画运行速度并不是绑定的。当解释器以单步运行时，动画模块依旧在以60帧每秒的速度播放动画。然而，控制模块提供了使两个模块同步的机制，使得动画不会提前或延后于解释器完成。


### 动画模块：


动画模块监视内存中的关键变量，并通过这些变量的状态来控制动画的进程。比如汉诺塔动画，动画模块只要监视三个变量（汉诺塔层数size，离开的柱子start和进入的柱子goal），就可以通过监视这些变量的数值改变来完成动画。首先动画模块将需要监视的变量的变量名传给控制器，在代码运行时，控制器就会将相应变量的内存地址回传给动画模块。由于动画模块被设计为“即插即用”，因此新增特定的动画并不需要重新编译主程序。


### UltraDemo文法



{% codeblock text lang:text %}


Program               ->  external_declaration
external_declaration  ->  Func_definitions
                       | external_decl_stmt
Func_definitions      ->  {Func_definition}+
Func_definition       ->  type id “(“ param_type_list “)” block
external_decl_stmt    ->
                       | type declarators “;”
Type                  ->  int
                       | float
                       | double
                       | char
                       | long
                       | ………….
Param_type_list       ->  type id {type_param}*
                       |
Type_param            ->  “,” type id
                       |
Block                 ->  “{“ stmts “}”
Stmts                 ->  decl_stmt
                       | if_stmt
                       | while_stmt
                       | for_stmt
                       | dowhile_stmt
                       | switch_stmt
                       | return_stmt
                       | assign
                       |
Decl_stmt             ->
                       | type declarators “;”
Declarators           ->  declarator { “,” declarator }
Declarator            ->  {Pointer}? id { arrayDeclarator}	? assignForDecl
Pointer               ->  “*” {pointer}?
arrayDeclarator       ->  “[“ {const_expr}? “]” {arrayDeclarator}?
const_expr            ->  conditional_expr
conditional_expr      ->  logical_expr
                       | logical_expr “?” expr : conditional_expr
assignForDecl         ->
                       | “=” expr
factor                ->  num
                       | “(“ expr “)”
                       | abstract_declarator
abstract_declarator   ->  id
                       | id “[“ expr “]”
                       | id “(“ param_list “)”
                       | id “->” abstract_declarator
                       | id “.” abstract_declarator
param_list            ->
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



格式化文法的工具请见：[http://everet.org/2012/03/the-format-grammer.html](http://everet.org/2012/03/the-format-grammer.html)


## UltraDemo开发人员


[华亮](http://EverET.org) [屠文翔](http://kidsang.com) [杨旭瑜](http://xuyufish.com) [罗嘉飞](http://jiafei.org) 安迪 杨明锦

UltraDemo的曾经的点滴：[http://everet.org/2012/02/ultrademo-interface-rewritten-in-c.html](http://everet.org/2012/02/ultrademo-interface-rewritten-in-c.html)

项目即将开源，敬请期待~~~
