---
layout: post
title: "Keep Learning"
date: 2013-01-03 00:14
comments: true
categories: Life
tags: [Python, PIL, Image Processing]
---
今天[屠文翔][tu]同学问了我一个在PIL中获取像素操作的问题，我想也没想就说道可以使用getpixel和putpixel操作像素，因为我之前一直也是使用这两个API。过了一会，[屠文翔][tu]同学问我是否用过load()这个API，我直接就说这个不是操作像素的。我之前在浏览PIL源码的时候，经常会见到调用这个函数，不过都只是纯调用，`self.load()`，连返回值都不获取。也没仔细看，就认为这个仅仅是装载数据。

<!-- more -->

``` python
##
# Allocates storage for the image and loads the pixel data.  In
# normal cases, you don't need to call this method, since the
# Image class automatically loads an opened image when it is
# accessed for the first time.
#
# @return An image access object.

def load(self):
    "Explicitly load pixel data."
    if self.im and self.palette and self.palette.dirty:
        # realize palette
        apply(self.im.putpalette, self.palette.getdata())
        self.palette.dirty = 0
        self.palette.mode = "RGB"
        self.palette.rawmode = None
        if self.info.has_key("transparency"):
            self.im.putpalettealpha(self.info["transparency"], 0)
            self.palette.mode = "RGBA"
    if self.im:
        return self.im.pixel_access(self.readonly)
```

于是乎就自以为是地认为，load()不是用于操作像素的。然后[屠文翔][tu]同学发来一条链接[Pixel Access Objects](http://effbot.org/zone/pil-pixel-access.htm)，顺带说了一句，“时代进步了“。

``` python
pix = im.load()

# get pixel value
print pix[x, y]

# put pixel value
pix[x, y] = value
```

嗯，确实，时代进步了，我老了，如果我不保持学习，所拥有的知识很多将会过时，甚至成为错误。

再仔细一看，这篇文章是2005年写的，新特性在1.1.6就加入了PIL，而我用的是1.1.7。

现在就说明一个问题，我自以为掌握了某些知识，其实是没有掌握的，而且其中甚至还有误解在里面。所以，对于”已经掌握的“知识，还需要经常温习，考证是否正确理解、是否全部掌握、是否慢慢遗忘。

## Keep Learning

又想起一句话：**学历代表过去，能力代表现在，学习力代表未来**。

对于在IT这个瞬息万变的行业，不能保持学习的兴趣与激情，迟早会被无情地淘汰。当然，除了学习，还要保持谦虚，保持低调，毕竟人总是会犯错的。如果自己很装逼地说什么就是什么，最后却发现自己错了，那岂不丢脸丢到家了。低调与谦虚，加上高效学习，2013年，加油！！！


[tu]: http://www.kidsang.com/
