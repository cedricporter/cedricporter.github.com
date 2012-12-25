---
comments: true
date: 2012-05-06 20:50:19
layout: post
slug: python-ascii-art
title: Python根据图片生成字符画
wordpress_id: 1012
categories:
- My Code
tags:
- Python
- Image Processing
---

字符画很好玩，我们来看看怎样将一张图片变成字符画。

我们首先将图片变成黑白的，那么每个像素的取值范围为：0-255.

然后我们将0-255映射到0-14的范围上，然后用如下字符代替：

color = 'MNHQ$OC?7>!:-;.'

也就是像素为0的点用“M”表示，像素为14的点用“.”表示。

原理非常的简单，我们用Python来编写的话也非常的简单。只要借助PIL，就可以很轻松地在Python中处理图像。

我们来看一段代码：<!-- more -->


{% codeblock python lang:python %}

import Image

color = 'MNHQ$OC?7>!:-;.'

def to_html(func):
    html_head = '''
            <html>
              <head>
                <style type="text/css">
                  body {font-family:Monospace; font-size:5px;}
                </style>
              </head>
            <body> '''
    html_tail = '</body></html>'

    def wrapper(img):
        pic_str = func(img)
        pic_str = ''.join(l + ' <br/>' for l in pic_str.splitlines())
        return html_head + pic_str + html_tail

    return wrapper

@to_html
def make_char_img(img):
    pix = img.load()
    pic_str = ''
    width, height = img.size
    for h in xrange(height):
        for w in xrange(width):
            pic_str += color[int(pix[w, h]) * 14 / 255]
        pic_str += '\n'
    return pic_str

def preprocess(img_name):
    img = Image.open(img_name)

    w, h = img.size
    m = max(img.size)
    delta = m / 200.0
    w, h = int(w / delta), int(h / delta)
    img = img.resize((w, h))
    img = img.convert('L')

    return img

def save_to_file(filename, pic_str):
    outfile = open(filename, 'w')
    outfile.write(pic_str)
    outfile.close()

def main():
    img = preprocess('6.jpg')
    pic_str = make_char_img(img)
    save_to_file('char.html', pic_str)

if __name__ == '__main__':
    main()

{% endcodeblock %}


整个程序的核心都在下面两行，一个是字符的色阶表，一个是映射公式。


> 

{% codeblock %}
color = 'MNHQ$OC?7>!:-;.'
pic_str += color[int(pix[w, h]) * 14 / 255]
{% endcodeblock %}




效果如下：

原图：

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-06-203607.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-06-203607.png)

字符画：

[![](http://everet.org/wp-content/uploads/2012/05/f8e22973ddcb35e46163c796bce096fcScreenshot-at-2012-04-25-161736.png)](http://everet.org/wp-content/uploads/2012/05/f8e22973ddcb35e46163c796bce096fcScreenshot-at-2012-04-25-161736.png)

在线的图片字符画生成请见：[http://everet.org:1758/](http://everet.org:1758/)

源码：[https://github.com/cedricporter/et-python/tree/master/web%20server/webpy](https://github.com/cedricporter/et-python/tree/master/web%20server/webpy)
