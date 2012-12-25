---
comments: true
date: 2012-07-15 17:10:04
layout: post
slug: effectlab
title: Python图像处理特效库EffectLab
wordpress_id: 1278
categories:
- 我的代码
tags:
- Python
- 图像处理
---

EffectLab是使用Python编写的一个快速测试图像处理特效的实验库，EffectLab目前基于PIL。方便测试图像处理算法。

EffectLab正在处于开发过程中（其实几天前才开始），日后会逐渐增加更多的特效。 目前特效处理用纯Python实现，这个运行速度十分地缓慢，所以后期会用C把部分特效重写。

我本人挺喜欢做图像处理的，想将EffectLab作为我们在两年前编写的图像处理程序[Imagination Factory](http://everet.org/2012/01/imagination-factory.html)的生命的延续。我想知道Photoshop里面的那些工具的究竟是怎么实现的，也非常感谢仔华给我一个与图像处理和安全相关的任务啊～因为目前做的一个东西的一部分需要进行些图像处理，于是决定将图像处理部分拆分出作为独立的图像特效库EffectLab来维护。

目前特效都设计为过滤器，接受一张图像和输出一张图像。不同的过滤器可以组合在一起形成新的特效过滤器。Unix的管道过滤器的思想真是美好啊。

{% codeblock python lang:python %}
new_effect = lambda img: effect_a(effect_b(effect_c(img)))
{% endcodeblock %}

源码请见Github: [https://github.com/cedricporter/EffectLab/downloads](https://github.com/cedricporter/EffectLab/downloads)


## 目前实现的效果


左边为原图，右边为处理后的图片。


### 镜头变形效果[1]


首先将图像映射到长宽取值范围都为[-1, 1]，然后从[笛卡尔坐标系](http://zh.wikipedia.org/zh/%E7%AC%9B%E5%8D%A1%E5%84%BF%E5%9D%90%E6%A0%87%E7%B3%BB)映射到[极坐标系](http://zh.wikipedia.org/wiki/%E6%9E%81%E5%9D%90%E6%A0%87%E7%B3%BB)。然后我们就可以控制![r](http://upload.wikimedia.org/wikipedia/zh/math/4/b/4/4b43b0aee35624cd95b910189b3dc231.png)（半径坐标）和![\theta](http://upload.wikimedia.org/wikipedia/zh/math/5/0/d/50d91f80cbb8feda1d10e167107ad1ff.png)（角坐标、极角或[方位角](http://zh.wikipedia.org/wiki/%E6%96%B9%E4%BD%8D%E8%A7%92)，有时也表示为![\phi](http://upload.wikimedia.org/wikipedia/zh/math/7/f/2/7f20aa0b3691b496aec21cf356f63e04.png)或![t](http://upload.wikimedia.org/wikipedia/zh/math/e/3/5/e358efa489f58062f10dd7316b65649e.png)）。

**r = r ^ 2**

{% codeblock python lang:python %}
effect = RadianFormulaEffect(lambda r, phi: (r ** 2, phi))
{% endcodeblock %}

<!-- more -->
[![](http://everet.org/wp-content/uploads/2012/07/5.jpg)](http://everet.org/wp-content/uploads/2012/07/5.jpg)

**r = sqrt(r)**

{% codeblock python lang:python %}
effect = RadianFormulaEffect(lambda r, phi: (sqrt(r), phi))
{% endcodeblock %}

[![](http://everet.org/wp-content/uploads/2012/07/1.jpg)](http://everet.org/wp-content/uploads/2012/07/1.jpg)

**x = math.sin(x * math.pi / 2)**
**y = math.sin(y * math.pi / 2)**

{% codeblock python lang:python %}
effect = LensWarpEffect(lambda x, y: (sin(x * math.pi / 2), sin(y * math.pi / 2)))
{% endcodeblock %}

[![](http://everet.org/wp-content/uploads/2012/07/4.jpg)](http://everet.org/wp-content/uploads/2012/07/4.jpg)


### 局部变形效果（液化）[2]


这个是Photoshop里面的液化效果。就是将照片作为液体胶泥一样，然后可以任意推动来变形。

[![](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-163959.png)](http://everet.org/wp-content/uploads/2012/07/Screenshot-from-2012-07-15-163959.png)

对于这个公式另开一片文章讲解。

下图鼠标起点圆心为(130, 120)，鼠标终点为(130, 50)，圆半径为100.也就是向上拖动。

{% codeblock python lang:python %}
effect = LocalWarpEffect((130, 120), (130, 50), 100)
{% endcodeblock %}

[![](http://everet.org/wp-content/uploads/2012/07/6.jpg)](http://everet.org/wp-content/uploads/2012/07/6.jpg)




## 参考资料





	
  1. [Image warping / distortion](http://paulbourke.net/miscellaneous/imagewarp/)

	
  2. Andreas Gustafsson, **Interactive Image Warping**


