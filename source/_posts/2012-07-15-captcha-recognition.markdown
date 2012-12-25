---
comments: true
date: 2012-07-15 19:52:14
layout: post
slug: captcha-recognition
title: Python验证码识别之预处理
wordpress_id: 1309
categories:
- IT
tags:
- Captcha
- Python
- Image Processing
---

对于验证码叙述，可以见上文[我们身边的验证码技术](http://everet.org/2012/07/captcha-around-us.html)。其中我们得知验证码识别流程如下图

[![](http://everet.org/wp-content/uploads/2012/07/2.png)](http://everet.org/wp-content/uploads/2012/07/2.png)

第一个主要步骤是数据预处理。


## 例子


一般的国内的验证都比较喜欢加上噪点，再加上一些干扰线，来扰乱视线。但是这些噪声，对于计算机识别程序来说，基本上没起到什么干扰。

我们来看看下面的验证码，这个是随机选择的15张验证码。左边为原图，右边的为处理过的图片。其中干扰线我们识别出来后用红色将其标记，噪点标红看不清楚我就直接去掉了。<!-- more -->

这样的验证码的大部分噪声非常轻易就可以去除。

因此，对于验证码来说，噪点的存在是对于抵抗机器人是毫无意义的，此外，这种长干扰线也是没什么太大的意义的，因为预处理就可以很轻松清除，增加这个只是会让人跟难受。

[![](http://everet.org/wp-content/uploads/2012/07/big.png)](http://everet.org/wp-content/uploads/2012/07/big.png)


## 移除噪点


首先我们来分析一下噪点由什么特性，噪点一般为孤立的点，最多也是会和其他的噪点粘在一起，所以总体来说，噪点相对于其他部分来说是孤立的小群体。

那我们可以对每一个连接在一起的块进行着色，Flood Fill专门干这事的。然后对于字符的块，必然是非常的大，而噪点的块，必然是非常的小。所以我们就可以轻松区分字符和噪点了。


## 移除干扰线


干扰线相对于噪点来说，虽然复杂了一点，但是还是非常的简单。

如何找到干扰线呢？干扰线的搜索问题是具有最优子结构的特性，于是这个问题我们可以用动态规划来解决[1]。

我们可以建立一个打分表，每个像素有一个分数。

动归的方程(如何画公式[2])为：

[![](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-194236.png)](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-194236.png)

[![](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-194246.png)](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-194246.png)

最后，评分最大的极有可能是干扰线。

这个实现起来非常的简单，就不放代码了，以免引起不必要的事端。


## 参考资料





	
  1. Ryan Fortune, Gary Luu, Peter McMahon, **CS229 Project Report: Cracking CAPTCHAs**

	
  2. OpenOffice.org Formula How-To


