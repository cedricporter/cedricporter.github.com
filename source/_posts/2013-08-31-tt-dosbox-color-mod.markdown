---
layout: post
title: "修改TT的配色"
date: 2013-08-31 16:57
comments: true
categories: IT
tags: [dosbox, tt]
---

## What is TT?
TT是一个16位的dos打字程序，已经有很久的历史了，现在基本只能在dosbox里面跑起来。

{% img /imgs/snapshot2_20130831_170030_3766Be0.png %}

TT的配色非常的鲜艳，艳绿色的背景配上白色文字，直接就要亮瞎我的狗眼。

如果连续对着这种颜色几个小时，眼睛都看不清楚东西了。所以我希望可以修改一下配色。改成不那么刺激的配色。

<!-- more -->

至于为什么要用TT呢，这是个好问题，我想最重要的一点是跨平台，虽然不是TT的功劳.......

## 修改方案

做完mini项目，决定开始动手改配色。想了一会，能够想到3种方案：

方案一是修改TT，这样的话其他人就不需要再修改了，不过TT是一个16位的dos程序，除了dos里面自带的非常难用的debug.exe，找不到其他好用的16位反汇编工具，所以就放弃这种方案。

方案二是修改dosbox，在dosbox这一层修改颜色映射。dosbox是C++写的，结构比较清晰，方便修改。

方案三是写一个第三方程序，修改dosbox这个窗口显示的颜色，这个在kde下会相对比较好做，不过不具备跨平台性。所以不考虑这种情况。

## 如何开始？

VGA的颜色表[^1]如下：

{% img /imgs/snapshot3_20130831_171355_3766znD.png %}

通过对比，我们很容易知道原来的TT的那恶心的绿色是10 Light Green。

我的想法是将所有TT用到的颜色在dosbox那里修改。

我们打开dosbox的源码在`src/hardware/vga_draw.cpp`里面的有一段是绘制文字的

``` cpp
static Bit32u FontMask[2]={0xffffffff,0x0};
static Bit8u * VGA_TEXT_Draw_Line(Bitu vidstart, Bitu line) {
    Bits font_addr;
    Bit32u * draw=(Bit32u *)TempLine;
    const Bit8u* vidmem = VGA_Text_Memwrap(vidstart);
    for (Bitu cx=0;cx<vga.draw.blocks;cx++) {
        Bitu chr=vidmem[cx*2];
        Bitu col=vidmem[cx*2+1];
        Bitu font=vga.draw.font_tables[(col >> 3)&1][chr*32+line];
        Bit32u mask1=TXT_Font_Table[font>>4] & FontMask[col >> 7];
        Bit32u mask2=TXT_Font_Table[font&0xf] & FontMask[col >> 7];
        Bit32u fg=TXT_FG_Table[col&0xf];
        Bit32u bg=TXT_BG_Table[col>>4];
        *draw++=(fg&mask1) | (bg&~mask1);
        *draw++=(fg&mask2) | (bg&~mask2);
    }
    if (!vga.draw.cursor.enabled || !(vga.draw.cursor.count&0x8)) goto skip_cursor;
    font_addr = (vga.draw.cursor.address-vidstart) >> 1;
    if (font_addr>=0 && font_addr<(Bits)vga.draw.blocks) {
        if (line<vga.draw.cursor.sline) goto skip_cursor;
        if (line>vga.draw.cursor.eline) goto skip_cursor;
        draw=(Bit32u *)&TempLine[font_addr*8];
        Bit32u att=TXT_FG_Table[vga.tandy.draw_base[vga.draw.cursor.address+1]&0xf];
        *draw++=att;*draw++=att;
    }
skip_cursor:
    return TempLine;
}
```
我们可以看到`Bit32u bg`这个变量，这个就是文字的背景色了。

我们来尝试一下，我们在
我们来判断一下，`Bit32u bg=TXT_BG_Table[col>>4];`下面加上一句`bg = 3;`也就是所有的背景色都变成Cyan，我们来看看效果：

{% img /imgs/snapshot4_20130831_172644_3766N8P.png %}

我X，肿么会这样，为什么会变成条纹状？！想了一会，想起dos字符是`80x20`的，像素是`320x200`，也即是横向是4个像素一个字符宽度。

通过打印bg出来，我们可以看到原来的亮绿色背景的bg值是`168430090`，二进制是`1010000010100000101000001010`。我们分段看一下： `1010,00001010,00001010,00001010`正好是4条竖线的颜色。确实是一个bg代表4个像素竖线的颜色。

## 正式开工

现在我们可以开始修改配色了，我们可以通过下面这段代码来快速获取需要的背景颜色：

``` python
make_color = lambda i: int(bin(i)[2:].rjust(8, "0") * 4, 2)
assert make_color(10) == 168430090  # light green
```

我们可以通过增加下面的代码来替换颜色，所以很傻，但是可以快速解决问题。

``` diff
375a376,378
>                 if (fg == 252645135) {   // 15:white
>                     fg = 117901063;      // 7:light gray
>                 }
376a380,385
>                 if (bg == 33686018) {   // 2:green
>                     bg = 0;             // 0:black
>                 }
>                 else if (bg == 16843009) { // 10:light green
>                     bg = 101058054;        // 6:brown
>                 }
```

下载patch：[tt-color.patch](/static/tt.patch )

## 完整流程

下面是在Ubuntu下的完整流程：

``` bash
# 下载dosbox源码
apt-get source dosbox
# 打补丁
wget http://EverET.org/static/tt.patch
cp tt.patch dosbox-0.74/src/hardware/
cd dosbox-0.74/src/hardware/
patch vga_draw.cpp tt.patch
cd ../../
# 编译
./configure --prefix=$HOME/my-dosbox
make -j4 && make install
```

然后就在~/my-dosbox/bin下面就有修改好的dosbox了，运行TT效果如下：

{% img /imgs/snapshot5_20130831_175653_3766nQc.png %}

是不是看上去舒服很多呢？

## Footnotes

[^1]: [VGA Basics](http://www.brackeen.com/vga/basics.html )
