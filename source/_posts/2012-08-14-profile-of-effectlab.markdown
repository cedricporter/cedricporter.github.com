---
comments: true
date: 2012-08-14 17:49:37
layout: post
slug: profile-of-effectlab
title: 对Python图像处理库EffectLab进行性能测试
wordpress_id: 1365
categories:
- My Code
tags:
- Python
- Image Processing
---

[EffectLab](http://everet.org/2012/07/effectlab.html)也是一个基于PIL的Python的图像库，目的是为了提供更多的特效处理以及更快的测试。

目前EffectLab可以实现的特效可以围观之前的文章：[http://everet.org/2012/07/effectlab.html](http://everet.org/2012/07/effectlab.html)。

古人云：_选择了脚本语言_就要忍受其速度。

但是，有时脚本语言的速度已经慢到了无法形容的地步时，我们就开始考虑性能优化了。


## 寻找性能热点


Python有一对很好的性能测试工具：cProfile与pstats。

我们来选择一个波浪效果来做测试：

{% codeblock python lang:python %}
img = Image.new("RGB", (100, 100))
wave = GlobalWaveEffect(1, 0.5)
test = partial(wave, img)

cProfile.run("test()", "profile.data")
p = pstats.Stats("profile.data")
p.strip_dirs().sort_stats("time").print_stats()
{% endcodeblock %}

我们可以看到其输出：<!-- more -->

{% codeblock console lang:console %}
Tue Aug 14 17:21:10 2012    profile.data

         417923 function calls (417922 primitive calls) in 0.434 seconds

   Ordered by: internal time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.150    0.150    0.434    0.434 Effect.py:92(filter)
    80000    0.068    0.000    0.068    0.000 {round}
    40000    0.051    0.000    0.063    0.000 Effect.py:304(transform)
    41889    0.034    0.000    0.034    0.000 {map}
    41890    0.029    0.000    0.042    0.000 Image.py:606(load)
    40000    0.028    0.000    0.091    0.000 Effect.py:317()
    33433    0.025    0.000    0.071    0.000 Image.py:946(getpixel)
    41890    0.013    0.000    0.013    0.000 {built-in method pixel_access}
    40000    0.012    0.000    0.012    0.000 {math.sin}
    33433    0.011    0.000    0.011    0.000 {built-in method getpixel}
     8457    0.008    0.000    0.019    0.000 Image.py:1260(putpixel)
     8457    0.004    0.000    0.004    0.000 {built-in method putpixel}
{% endcodeblock %}

可以发现，运行时间最长的函数有[第92行的filter](https://github.com/cedricporter/EffectLab/blob/master/EffectLab/Effect.py#L92)，以及[第304行的transform](https://github.com/cedricporter/EffectLab/blob/master/EffectLab/Effect.py#L304)。我们可以查看第92行的函数filter，这个函数看上去非常的简短，主要做的是处理每一个像素以及有抗锯齿运算。

{% codeblock python lang:python %}
def filter(self, img):
    width, height = img.size
    new_img = Image.new(img.mode, img.size, Effect.empty_color)

    nband = len(img.getpixel((0, 0)))
    antialias = self.antialias
    left, top, right, bottom = self.box if self.box else (0, 0, width, height)

    for x in xrange(left, right):
        for y in xrange(top, bottom): 
            found = 0
            psum = (0, ) * nband

            # anti-alias
            for ai in xrange(antialias):
                _x = x + ai / float(antialias)
                for aj in xrange(antialias):
                    _y = y + aj / float(antialias)

                    u, v = self.formula(_x, _y)

                    u = int(round(u))
                    v = int(round(v))
                    if not (0 <= u < width and 0 <= v < height):
                        continue
                    pt = img.getpixel((u, v))
                    psum = map(operator.add, psum, pt)
                    found += 1 

            if found > 0:
                psum = map(operator.div, psum, (found, ) * len(psum)) 
                new_img.putpixel((x, y), tuple(psum))

    return new_img 

{% endcodeblock %}

以及transform函数：

{% codeblock python lang:python %}
def transform(self, x, y, width, height, delta_w, delta_h):
    radian = 2 * math.pi * (x + self.xoffset) / float(width) * delta_w
    offset = 0.5 * sin(radian) * height * delta_h

    return x, y + offset
{% endcodeblock %}



## 解决性能热点


嗯，这个看上去热点都是纯计算的代码，貌似已经没什么优化的空间了，这时怎么办呢？

鉴于CPython可以非常容易的使用C/C++扩展模块，我们用C语言来实现里面这些纯计算的部分，看看性能有什么提升。

我们用C来实现Filter函数。重新运行cProfile看看，

{% codeblock console lang:console %}
Tue Aug 14 17:38:56 2012    profile.data

         12 function calls in 0.002 seconds

   Ordered by: internal time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.002    0.002    0.002    0.002 {EffectLab.EffectLabCore.wave_warp}
        1    0.000    0.000    0.000    0.000 {built-in method copy}
        1    0.000    0.000    0.000    0.000 Image.py:460(_new)
        1    0.000    0.000    0.000    0.000 Image.py:740(copy)
        1    0.000    0.000    0.002    0.002 Effect.py:310(filter)
        1    0.000    0.000    0.002    0.002 :1()
        1    0.000    0.000    0.000    0.000 Image.py:606(load)
        1    0.000    0.000    0.002    0.002 Effect.py:37(__call__)
        1    0.000    0.000    0.000    0.000 Image.py:449(__init__)
        1    0.000    0.000    0.000    0.000 {built-in method pixel_access}
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
        1    0.000    0.000    0.000    0.000 {method 'copy' of 'dict' objects}
{% endcodeblock %}

此时热点函数已经被C语言的模块给替换了。

我们用timeit模块统计一下运行时间，统计代码如下（其中test函数见上面，里面就是调用了波浪处理效果：

{% codeblock python lang:python %}
t = Timer('test()', 'from __main__ import test') 
N = 3
TIMES = 30
print sum(t.repeat(N, TIMES)) / N / TIMES * 1000, 'ms'
{% endcodeblock %}



## 结果


我们来看看运行3轮，每轮运行30次，平均一次的时间是多少。
Python版本的平均一次时间为：**303.63 ms**

C版本平均一次时间为：**1.91 ms**

可见运行速度是原来的**159倍**。


