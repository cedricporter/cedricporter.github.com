---
comments: true
date: 2012-01-24 23:31:43
layout: post
slug: pil-brief-intro
title: Python进行图像处理——PIL简介
wordpress_id: 274
categories:
- My Code
tags:
- Python
- Image Processing
---

PIL中包括Image，ImageEnhance，ImageGrab等。


## Image


Image模块仅用一个类来表示PIL中的图像，并提供了许多工厂函数，不同类型的图像可以使用统一的接口进行处理。

[http://www.pythonware.com/library/pil/handbook/image.htm](http://www.pythonware.com/library/pil/handbook/image.htm)


### 主要函数（可以顾名思义，这里主要有个提纲，方便记忆）有：



```
**Image.new(mode, size)** => image

**Image.new(mode, size, color)** => image

**Image.open(infile)** => image

**Image.open(infile, mode)** => image

**Image.blend(image1, image2, alpha)** => image<!-- more -->

**im.convert(mode)** => image

**im.convert(mode, matrix)** => image

**im.copy()** => image

**im.crop(box)** => image

**im.paste(image, box)**

**im.paste(colour, box)**

**im.paste(image, box, mask)**

**im.paste(colour, box, mask)**

**im.resize(size)** => image

**im.resize(size, filter)** => image

**im.save(outfile, _options..._)**

**im.save(outfile, format, _options..._)**

**im.seek(frame)**   可用于gif

**im.split()** => sequence    RGB通道分离

**im.transpose(method)** => image
```



## ImageEnhance


图像增强，锐化，对比度，亮度的处理。

[http://www.pythonware.com/library/pil/handbook/imageenhance.htm](http://www.pythonware.com/library/pil/handbook/imageenhance.htm)




## ImageGrab


ImageGrab模块可以进行屏幕截图。也可以复制剪切板中的图像。不过手册说仅仅适用于Windows。

[http://www.pythonware.com/library/pil/handbook/imagegrab.htm](http://www.pythonware.com/library/pil/handbook/imagegrab.htm)

```
**ImageGrab.grab()** => image

**ImageGrab.grab(bbox)** => image

**ImageGrab.grabclipboard()** => image or list of strings or None
```




## ImageDraw


可以画2D图。

[http://www.pythonware.com/library/pil/handbook/imagedraw.htm](http://www.pythonware.com/library/pil/handbook/imagedraw.htm)
