---
comments: true
date: 2012-02-19 13:23:35
layout: post
slug: intermediate-code-generation
title: 编译原理知识回顾——中间代码生成
wordpress_id: 567
categories:
- IT
tags:
- compile
---

学完编译原理已经一年了，也有半年被因为学其他东西而没空继续深入学习编译原理。

 

现在终于有机会继续学习了。

 

首先回顾下，编译原理考试第一题的答案。就是翻译的步骤。

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb4.png)](http://everet.org/wp-content/uploads/2012/02/image4.png)

<!-- more -->

对于编译，第一步是词法分析。也就是分出一个个Token。

 

例如，像一行赋值语句：a[index] = 4 + 2 ，我们可以将其拆成一个个基本元素，每种元素都有自己的类型。如下所示：

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb5.png)](http://everet.org/wp-content/uploads/2012/02/image5.png)


这些Token将作为编译过程中最基本的元素。
      
标识符(identifier) a, index
      
左方括号(left bracket) [
          
右方括号(right bracket) ] 
      
等号(assignment) =
          
加号(plus) + 
      
数字(number) 4, 2

当这些Token它们组合在一起，就成了句子。在这个时候，我们就可以进行语法分析了。
 

我们可以将其组织成一棵抽象的语法树。根节点就是抽象的表达式，因为这个一句话就是一个表达式。然后可以分割为赋值表达式的3个元素，然后逐级分割，到了叶子就是基本的词法单元Token了。

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb6.png)](http://everet.org/wp-content/uploads/2012/02/image6.png)

 

在做完语法分析后，我们就要进行语义分析。为什么要语义分析呢？我们要根据语义来标记这棵语法树，让其变成标记树，然后才好根据这棵树生成中间代码。

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb7.png)](http://everet.org/wp-content/uploads/2012/02/image7.png)

 

通常，我们的中间代码都是一种三地址码。可以理解为只有三个变量以内的表达式。

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb8.png)](http://everet.org/wp-content/uploads/2012/02/image8.png)

 

对于三地址码，我们可以进行代码优化，例如想上述的代码可以优化成：

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb9.png)](http://everet.org/wp-content/uploads/2012/02/image9.png)

 

对于优化后的中间代码，我们可以方便的将其翻译成汇编代码。

 

我们假设变量a的类型是占4个字节。于是可以翻译成下述汇编

 

[![image](http://everet.org/wp-content/uploads/2012/02/image_thumb10.png)](http://everet.org/wp-content/uploads/2012/02/image10.png)

 

于是关于代码生成的部分就完成了。
