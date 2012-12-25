---
comments: true
date: 2012-07-08 22:47:01
layout: post
slug: captcha-around-us
title: 我们身边的验证码技术
wordpress_id: 1254
categories:
- IT
tags:
- Captcha
---

验证码大家几乎经常都会碰到，不过很多时候，我们都仅仅只是输入完事，很少去思考验证码其背后的东西。验证码的英文名叫**CAPTCHA**，全称为**Completely Automated Public Turing test to tell Computers and Humans Apart**（**全自动区分计算机和人类的图灵测试**）。验证码提供一个区分人与机器的手段，主要目的是将机器人拒之门外。

现在的各种网络服务已经成为我们生活的重要的组成部分，像各种社交网站，购物网站，网上银行，投票，论坛等服务，为我们的带来的极大的便利。然而，这些系统都在遭受着恶意程序的滥用。所以，验证码系统用于阻挡这些恶意程序。


## 验证码CAPTCHA存在的意义


现在，每天有2亿的验证码CAPTCHA被人类识别出来。我们可利用其解决一些计算机难以处理或者耗费大量人力的问题。目前，像Google的[reCAPTCHA](http://www.google.com/recaptcha/aboutus)项目，就是利用验证码来数字化图书和报纸。而像一些广告公司将广告融入了验证码，让人们在输入验证码的时候输入广告中的特定部分，但是这种验证码的样本必然会比较少，因为较难产生大量的广告验证码，所以很容易被破解。

因为CAPTCHA的需求量十分巨大，所以CAPTCHA需要能够自动产生并且评估正确性。此外，人类必须要能够快速地识别并输入验证码，否则容易惹恼用户以至于用户流失。对于CAPTCHA，可以引入人工智能领域的难题，来使现有技术短期无法成功破解。如果一种CAPTCHA没有被破解，那么就有一个可以区分人类和计算机的方法。如果CAPTCHA被破解了，那么一个人工智能的问题也就随之解决了。


## 验证码CAPTCHA的困境<!-- more -->


计算机程序可以一天24小时不间断运行，即使是在较低的识别率也可以在较短的时间内大量穿越CAPTCHA系统。所以CAPACHA的识别率需要低于0.01%才可以有效地阻挡自动化的恶意程序的攻击。当然，也可以通过IP辅助来限制一台机器的尝试次数。


## CAPTCHA的类型


CAPTCHA主要分成3类——文本、图像和声音。


### 文本验证码（Text-based CAPTCHA)


文本验证码方便计算机自动地大量产生，是目前应用最多的最广泛的技术。文本验证码主要靠图像变形和添加噪声。

文本验证码破解难点主要在于字符的分割和识别。其中字符分割是破解文本验证码的关键。主要步骤是：第一步，分割字符，第二步，单个字符识别，其中单个字符的识别在现有的机器学习算法下可以很容易的识别。

所以防范对文本验证码的攻击的关键在于加大字符分割的难度。像Google等公司的验证码[5]都是粘连在一起，分割难度大。

[![](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-08-223255.png)](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-08-223255.png)

验证码识别的主要流程一般都较为固定。


#### 识别流程


[![](http://everet.org/wp-content/uploads/2012/07/2.png)](http://everet.org/wp-content/uploads/2012/07/2.png)


#### 分割


下图为垂直投影字符分割[7]

[![](http://everet.org/wp-content/uploads/2012/07/Selection_012.png)](http://everet.org/wp-content/uploads/2012/07/Selection_012.png)


### 图像验证码（Image-based CAPTCHA）


图像验证码基于图像分类、目标识别、场景理解等问题，一般情况下比文本验证码更加难以破解，但是现有的图像验证码需要庞大的图像数据库，而且无法大规模产生。更糟糕的是，一旦数据库被公布，算法不功自破。[6]

[![](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-08-224238.png)](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-08-224238.png)


### 声音验证码（Sound-based CAPTCHA）


声音验证码以随机间隔播放随机选择的一个或多个人播报的数字字母，再添加背景噪声。声音验证码容易收到机器学习算法的攻击。而且相对于视觉上的验证码，用户友好性更低。对于字母的声音，可能农村地区的少部分群体会因为对于字母发音不熟悉而导致无法理解，而无法通过测试。


## 参考资料





	
  1. Jeff Yan, Ahmad Salah El Ahmad, **A Low-cost Attack on a Microsoft CAPTCHA**

	
  2. 李秋洁 茅耀斌 王执铨, **CAPTCHA技术研究综述**

	
  3. Prof. (Mrs.) A.A. Chandavale,  Prof. Dr.A.M. Sapkal, Dr.R.M.Jalnekar, **Algorithm To Break Visual CAPTCHA**

	
  4. Shujun Li, S. Amier Haider Shah, ...,   **Breaking e-Banking CAPTCHAs**

	
  5. Ibrahim Furkan Ince, Ilker Yengin, Yucel Batu Salman, **DESIGNING CAPTCHA ALGORITHM: SPLITTING AND ROTATING**

	
  6. Michele Merler (mm3233), Jacquilene Jacob (jj2442),  **BREAKING AN IMAGE BASED CAPTCHA**

	
  7. Shih-Yu Huang, Yeuan-Kuen Lee, Graeme Bell and Zhan-he Ou, **An Efficient Segmentation Algorithm for CAPTCHAs with Line Cluttering and Character Warping**


