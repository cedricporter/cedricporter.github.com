---
comments: true
date: 2012-06-13 14:55:56
layout: post
slug: python-dot-product
title: Python计算点积
wordpress_id: 1227
categories:
- IT
tags:
- C++
- Python
---

想起我们在C++中，要实现一个点积，如果是固定维数的向量，我们或许会通过这么一个成员函数来实现

{% codeblock cpp lang:cpp %}

Point2d DotProduct(const Point2d& rhs)
{
    return Point2d(m_x * rhs.x(), m_y * rhs.y());
}

{% endcodeblock %}

对于非固定维数的向量，我们或许动用一个循环，然后又变成了一坨代码。

当我们使用Python的时候，就会简单很多很多。<!-- more -->

{% codeblock python lang:python %}

In [6]: dotproduct = 
           lambda v1, v2: sum(itertools.imap(operator.mul, v1, v2))

In [7]: dotproduct([1,2], [3,4])
Out[7]: 11

In [8]: dotproduct((1,3,5), (4,5,7))
Out[8]: 54

In [9]: dotproduct((1,3,5,10,6), (4,5,7,2,4))
Out[9]: 98

{% endcodeblock %}

