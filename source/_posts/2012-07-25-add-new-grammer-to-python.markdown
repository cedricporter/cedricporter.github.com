---
comments: true
date: 2012-07-25 21:43:28
layout: post
slug: add-new-grammer-to-python
title: '走进Python: 为Python增加新语法'
wordpress_id: 1326
categories:
- Translation
tags:
- compile
- Python
---

**原文地址：**[http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/)

**译文地址：**[http://everet.org/2012/07/add-new-grammer-to-python.html](http://everet.org/2012/07/add-new-grammer-to-python.html)

**译者：**[Stupid ET](http://EverET.org)

翻译得比较仓储，里面会有些语句不通顺，请见谅，日后会慢慢重构。
修改后的Python请见：[https://github.com/cedricporter/python2.7-mod/tags](https://github.com/cedricporter/python2.7-mod/tags) ，在Ubuntu下可以正常编译。



* * *



本文的目的是试图更好地理解Python的前端是如何工作的。如果我们仅仅是阅读文档和源代码，那么可能有点无聊，所以我将亲手实践：为Python添加一个until语句。

这篇文章中的所有的编码,是针对最新的Py3k分支[Python Mercurial repository mirror](http://code.python.org/hg/branches/py3k/)。


### until语句


有些语言，像Ruby，拥有until语句，用来补充while语句 (until num == 0 等价与 while num != 0)。在Ruby总，我可以这样写：

{% codeblock python lang:python %}
num = 3
until num == 0 do
  puts num
  num -= 1
end
{% endcodeblock %}

它会输出

{% codeblock python lang:python %}
3
2
1
{% endcodeblock %}

所以,我想要添加一个类似的功能到Python。也就是说,能够写成这样:

{% codeblock python lang:python %}
num = 3
until num == 0:
  print(num)
  num -= 1
{% endcodeblock %}

<!-- more -->




### A language-advocacy digression（不知如何翻译）


本文并没有企图建议添加一个Until语句到Python。虽然我认为这样的语句会让一些代码清晰,而且这篇文章也展示了这是多么容易为Python添加这样的语句，但我非常尊重Python的简约主义的哲学。所以我在这里做的一切，仅仅是为了更能了解Python的内部工作原理。


### 修改语法


Python使用一个自定义解析器生成器pgen。这是一个LL(1)的解析器，用于将Python源代码转换成一个解析树。解析器生成器的输入文件  Grammar/Grammar [[1]](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/#id4)。这是一个简单的文本文件，用于定义Python的语法。 我们对这个语法文件进行了两处修改。第一个是添加until语句的定义。我发现那里的while语句定义为(while_stmt),于是我们在下面补充until_stmt[2]:

{% codeblock python lang:python %}
compound_stmt: if_stmt | while_stmt | until_stmt | for_stmt | try_stmt | with_stmt | funcdef | classdef | decorated
if_stmt: 'if' test ':' suite ('elif' test ':' suite)* ['else' ':' suite]
while_stmt: 'while' test ':' suite ['else' ':' suite]
until_stmt: 'until' test ':' suite
{% endcodeblock %}

注意，我决定了从我定义的until语句中去掉else子句，只是为了让他们有点不同（因为，坦率地说，我不喜欢循环的else子句，认为它有悖于the Zen of Python）。
第二个变化是修改规则compound_stmt，正如上面你所见到的那样，让它可以推导成until_stmt。我们把它放在while_stmt的右边。
当您在修改完**Grammar/Grammar**后准备运行make时注意运行pgen程序运行时重新生成Include/graminit.h以及Python/graminit.c再重新编译。
**（译注：cedricporter@Stupid-ET:~/projects/python2.7-2.7.2/Parser$ ./pgen ../Grammar/Grammar graminit.h graminit.c）**


### 修改AST生成代码


在Python的解析器创建了一个解析树后,这棵树被转换成一个AST（译注：抽象语法树），因为AST让后续的编译流程更简单。

所以,我们打开Parser/Python.asdl，它定义了结构的Python的抽象语法树，我们在那里为我们新增的until语句添加一个AST节点，又放在while的右后方:

{% codeblock python lang:python %}
| While(expr test, stmt* body, stmt* orelse)
| Until(expr test, stmt* body)
{% endcodeblock %}

If you now run make, notice that before compiling a bunch of files, Parser/asdl_c.py is run to generate C code from the AST definition file. This (like Grammar/Grammar) is another example of the Python source-code using a mini-language (in other words, a DSL) to simplify programming. Also note that since Parser/asdl_c.py is a Python script, this is a kind of [bootstrapping](http://en.wikipedia.org/wiki/Bootstrapping_%28compilers%29) – to build Python from scratch, Python already has to be available.
如果你现在运行make,请注意在编译一堆文件之前, 运行Parser/asdl_c.py根据AST定义文件生成的C代码。这(如Grammar/Grammar)是另一个Python源代码使用迷你语言(换句话说,一个DSL)来简化编程的例子。还请注意,由于Parser/asdl_c.py是一个Python脚本,这是一种自举——从原型中构建Python。Python已经拥有自举的能力了。

虽然**Parser/asdl_c.py**生成的代码管理着我们的新定义的AST节点(生成到文件**Include/Python-ast.h**和**Python/Python-ast.c中**)，我们仍然需要编写的代码,将一个相关的解析树节点转换成我们新定义的AST节点。

**（译注：cedricporter@Stupid-ET:~/projects/python2.7-2.7.2/Parser$ ./asdl_c.py -h ../Include/ Python.asdl ）**

这些工作在 **Python/ast.c**中完成。在那里,一个叫做 ast_for_stmt的函数将解析树节点转换为AST节点。我们再次在我们的老朋友while的引导下，进入处理compound_stmt的庞大的switch中，为until增加一个子块：

{% codeblock c lang:c %}
case while_stmt:
    return ast_for_while_stmt(c, ch);
case until_stmt:
    return ast_for_until_stmt(c, ch);
{% endcodeblock %}

现在我们要实现ast_for_until_stmt：

{% codeblock c lang:c %}
static stmt_ty
ast_for_until_stmt(struct compiling *c, const node *n)
{
    /* until_stmt: 'until' test ':' suite */
    REQ(n, until_stmt);

    if (NCH(n) == 4) {
        expr_ty expression;
        asdl_seq *suite_seq;

        expression = ast_for_expr(c, CHILD(n, 1));
        if (!expression)
            return NULL;
        suite_seq = ast_for_suite(c, CHILD(n, 3));
        if (!suite_seq)
            return NULL;
        return Until(expression, suite_seq, LINENO(n), n->n_col_offset, c->c_arena);
    }

    PyErr_Format(PyExc_SystemError,
                 "wrong number of tokens for 'until' statement: %d",
                 NCH(n));
    return NULL;
}
{% endcodeblock %}



再一次,这是看起来像ast_for_while_stmt，不过不同的是，它不支持else子句。也正如预期的那样，在until语句的主体中使用其他AST创建函数像ast_for_expr对于条件表达式和 ast_for_suite来递归地创建AST。最后，一个until新节点被创建返回。

注意,我们通过一些宏，像NCH和CHILD来访问解析树节点。这些都是值得我们去理解——他们的代码在**Include/node.h**.


### 题外话：AST组合


我选择创建一个新until类型的AST,但实际上这是没有必要的。虽然我能通过实现组合现有的AST节点来节省一些工作:

{% codeblock python lang:python %}
until condition:
   # do stuff
{% endcodeblock %}

功能上等价于:

{% codeblock python lang:python %}
while not condition:
  # do stuff
{% endcodeblock %}

与其在ast_until_stmt里面创建一个新的Until节点，我可以创建一个Not节点下面挂上While节点。因为AST解释器已经知道如何处理这些节点，所以下一步可以跳过了。


### 将AST变成字节码


The next step is compiling the AST into Python bytecode. The compilation has an intermediate result which is a CFG (Control Flow Graph), but since the same code handles it I will ignore this detail for now and leave it for another article.

下一步是将AST解析成字节码。编译过程中有一个中间结果CFG(控制流图)，但由于有相同的代码处理它，所以我暂时先忽略这一细节，留到另一篇文章再讲解。

下一步，们将看看Python/compile.c。在while的带领下，我们找到负责将语句编译成字节码的函数compiler_visit_stmt。在这里，我们为Until添加一个子句:

{% codeblock c lang:c %}
case While_kind:
    return compiler_while(c, s);
case Until_kind:
    return compiler_until(c, s);
{% endcodeblock %}

想必你也想知道Until_kind是什么，它是一个根据AST定义自动生成到Include/Python-ast.h的常量(实际上是一个_stmt_kind的枚举)。当然，我们调用的compiler_until还不存在。我等等就会实现它。

如果你好奇的像我一样,你会注意到compiler_visit_stmt非常特别。再多的 grep平源树能揭示它叫。在这种情况下,只有一个选择仍然macro-fu - C。事实上,一个简短的调查使我们进入了 访问宏定义在 Python / compile.c:

{% codeblock c lang:c %}
#define VISIT(C, TYPE, V) {\
    if (!compiler_visit_ ## TYPE((C), (V))) \
        return 0; \
{% endcodeblock %}

在compiler_body中，它是用来调用compiler_visit_stmt的。

正如之前说的那样，我们在这里给出compiler_until:

{% codeblock c lang:c %}
static int
compiler_until(struct compiler *c, stmt_ty s)
{
    basicblock *loop, *end, *anchor = NULL;
    int constant = expr_constant(s->v.Until.test);

    if (constant == 1) {
        return 1;
    }
    loop = compiler_new_block(c);
    end = compiler_new_block(c);
    if (constant == -1) {
        anchor = compiler_new_block(c);
        if (anchor == NULL)
            return 0;
    }
    if (loop == NULL || end == NULL)
        return 0;

    ADDOP_JREL(c, SETUP_LOOP, end);
    compiler_use_next_block(c, loop);
    if (!compiler_push_fblock(c, LOOP, loop))
        return 0;
    if (constant == -1) {
        VISIT(c, expr, s->v.Until.test);
        ADDOP_JABS(c, POP_JUMP_IF_TRUE, anchor);
    }
    VISIT_SEQ(c, stmt, s->v.Until.body);
    ADDOP_JABS(c, JUMP_ABSOLUTE, loop);

    if (constant == -1) {
        compiler_use_next_block(c, anchor);
        ADDOP(c, POP_BLOCK);
    }
    compiler_pop_fblock(c, LOOP, loop);
    compiler_use_next_block(c, end);

    return 1;
}
{% endcodeblock %}

我必须得承认，这些代码是在我没有深刻理解Python字节码的前提下编写的。就像接下来的文章那样，它仅仅是模仿它的亲戚函数compiler_while。我们通过仔细阅读，知道Python虚拟机是基于栈的，大致看了一下dis模块的文档，发现那里有[一系列Python字节码的描述](http://docs.python.org/py3k/library/dis.html).


### 嗯！我们完成了，不是吗？


在修改完后，我们运行make，然后我们运行我们新编译出来的Python来测试我们新增的until语句：

{% codeblock python lang:python %}
>>> until num == 0:
...   print(num)
...   num -= 1
...
3
2
1
{% endcodeblock %}

瞧！它能够工作！我们通过dis模块来看看新语句的字节码：

{% codeblock python lang:python %}
import dis

def myfoo(num):
    until num == 0:
        print(num)
        num -= 1

dis.dis(myfoo)
{% endcodeblock %}

Here’s the result:

{% codeblock python lang:python %}
4           0 SETUP_LOOP              36 (to 39)
      >>    3 LOAD_FAST                0 (num)
            6 LOAD_CONST               1 (0)
            9 COMPARE_OP               2 (==)
           12 POP_JUMP_IF_TRUE        38

5          15 LOAD_NAME                0 (print)
           18 LOAD_FAST                0 (num)
           21 CALL_FUNCTION            1
           24 POP_TOP

6          25 LOAD_FAST                0 (num)
           28 LOAD_CONST               2 (1)
           31 INPLACE_SUBTRACT
           32 STORE_FAST               0 (num)
           35 JUMP_ABSOLUTE            3
      >>   38 POP_BLOCK
      >>   39 LOAD_CONST               0 (None)
           42 RETURN_VALUE
{% endcodeblock %}

最有趣的是编号12的字节码：如果条件为真，我们跳转到循环的后面。这个符合until的语义。如果jump没有被执行，循环体就继续运行，直到它跳转到编号35的字节码。

我对我的修改自我感觉良好，于是我继续测试这个函数（执行myfoo(3)），结果并不令人振奋：

{% codeblock python lang:python %}
Traceback (most recent call last):
  File "zy.py", line 9, in 
    myfoo(3)
  File "zy.py", line 5, in myfoo
    print(num)
SystemError: no locals when loading 'print'
{% endcodeblock %}

哇...这个真是悲剧。究竟哪里出错了？


### 丢失符号


在解析AST的时候，Python解析器执行的步骤之一是构建符号表。通过在PyAST_Compile里面调用PySymtable_Build（Python/symtable.c）来遍历AST。拥有每一个作用域的符号表有助于编译器找出一些关键的信息，就像哪些变量是全局的，哪些变量是局部的。

我们需要修改Python/symtable.c下的symtable_visit_stmt来解决这个问题，我们添加一些处理until语句的代码，放在相似的while语句的代码后面 [[3]](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/#id6):：

{% codeblock c lang:c %}
case While_kind:
    VISIT(st, expr, s->v.While.test);
    VISIT_SEQ(st, stmt, s->v.While.body);
    if (s->v.While.orelse)
        VISIT_SEQ(st, stmt, s->v.While.orelse);
    break;
case Until_kind:
    VISIT(st, expr, s->v.Until.test);
    VISIT_SEQ(st, stmt, s->v.Until.body);
    break;
{% endcodeblock %}

现在，我们真的完成了。修改后的源码可以在myfoo(3)运行正常。


### 结论


在本文中，我展示了如何为Python增加一个新语句。尽管需要比较多处的修改Python编译器，但是这些修改并不难，因为我跟随着一个相似的语句来修改。

Python编译器适宜隔非常复杂的程序，我不想自称专家。然而，我真的对Python内部实现相当感兴趣，特别是前端。因此，我发现这种练习是一个编译理论与实践的结合。它将作为后续文章的基础来更深层次地探究编译器。


### 参考


I used a few excellent references for the construction of this article. Here they are, in no particular order:



	
  * [PEP 339: Design of the CPython compiler](http://www.python.org/dev/peps/pep-0339/) – probably the most important and comprehensive piece of _official_ documentation for the Python compiler. Being very short, it painfully displays the scarcity of good documentation of the internals of Python.

	
  * "Python Compiler Internals" – an article by Thomas Lee

	
  * "Python: Design and Implementation" – a presentation by Guido van Rossum

	
  * Python (2.5) Virtual Machine, A guided tour – a presentation by Peter Tröger


![http://eli.thegreenplace.net/wp-content/uploads/hline.jpg](https://www.evernote.com/shard/s144/res/25bdd2c0-7952-4d98-8e91-46cd69bd606a.jpg)








[[1]](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/#id1)


From here on, references to files in the Python source are given relatively to the root of the source tree, which is the directory where you run configure and make to build Python.












[[2]](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/#id2)


This demonstrates a common technique I use when modifying source code I’m not familiar with: _work by similarity_. This principle won’t solve all your problems, but it can definitely ease the process. Since everything that has to be done forwhile also has to be done for until, it serves as a pretty good guideline.












[[3]](http://eli.thegreenplace.net/2010/06/30/python-internals-adding-a-new-statement-to-python/#id3)


By the way, without this code there’s a compiler warning for Python/symtable.c. The compiler notices that theUntil_kind enumeration value isn’t handled in the switch statement of symtable_visit_stmt and complains. It’s always important to check for compiler warnings!




