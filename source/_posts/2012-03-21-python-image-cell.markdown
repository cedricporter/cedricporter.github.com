---
comments: true
date: 2012-03-21 19:46:24
layout: post
slug: python-image-cell
title: Python进行图像处理——生成交替颜色的格子图
wordpress_id: 777
categories:
- My Code
tags:
- Python
- Image Processing
---

今天小孟师兄要一张贴图做测试，屠文翔同学用Fireworks花了两分钟做了下面的一张图片。但是师兄说要一张颜色相隔的图片，于是Fireworks此时就显得有点力不从心了。于是此时Python就要上场啦。

Fireworks生成的图：

[![rects](http://everet.org/wp-content/uploads/2012/03/rects_thumb.png)](http://everet.org/wp-content/uploads/2012/03/rects.png)

好，下面，我们来用Python的PIL库来敏捷地生成一个颜色相隔的格子图。只需要10行代码。

<!-- more -->

[![QQ截图20120321193734](http://everet.org/wp-content/uploads/2012/03/QQ20120321193734_thumb.png)](http://everet.org/wp-content/uploads/2012/03/QQ20120321193734.png)


{% codeblock python lang:python %}

import Image, ImageDraw

im = Image.open('1.bmp')
draw = ImageDraw.Draw(im)
count = 0

for i in range(52):
    for j in range(51):
        count += 1
        if count % 2 == 0:
            draw.rectangle((i * 10, j * 10, (i+1) * 10, (j+1)*10),fill="#ff0000")

im.save('test.bmp')

{% endcodeblock %}


下面是师兄写的引擎写的地形贴上Python生成的大姨妈图：
[![](http://everet.org/wp-content/uploads/2012/03/QQ截图20120321201014.png)](http://everet.org/wp-content/uploads/2012/03/QQ截图20120321201014.png)
