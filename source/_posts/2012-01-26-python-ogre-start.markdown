---
comments: true
date: 2012-01-26 21:02:52
layout: post
slug: python-ogre-start
title: Python与OGRE之开篇
wordpress_id: 282
categories:
- My Code
tags:
- OGRE
- Python
---

OGRE是什么？百度百科给的解释是：“OGRE（Object-Oriented Graphics Rendering Engine，即：面向对象图形渲染引擎）是一个用C++开发的面向场景、非常灵活的3D引擎，它旨在让开发人员更容易、更直接地利用硬件加速的3D图形系统开发应用。这个类库隐藏了底层系统库（如：Direct3D和OpenGL）的所有细节，提供了一个基于世界对象和其他直观类的接口。 译者注:ogre在英文中意为：食人魔鬼, 怪物, 象鬼的人，故其LOGO是一个怪物头。”

Python是什么？“Python是一种面向对象、直译式计算机程序设计语言，由[Guido van Rossum](http://baike.baidu.com/view/2975166.htm)于1989年底发明， 第一个公开发行版发行于1991年。Python语法简捷而清晰，具有丰富和强大的类库。它常被昵称为胶水语言，它能够很轻松的把用其他语言制作的各种模块（尤其是C/C++）轻松地联结在一起。常见的一种应用情形是，使用python快速生成程序的原型（有时甚至是程序的最终界面），然后对其中有特别要求的部分，用更合适的语言改写，比如3D游戏中的图形渲染模块，速度要求非常高，就可以用C++重写。”摘自百度百科。


## Python+OGRE=？


<!-- more -->


## 


Python+OGRE=开发速度+简介的代码+良好的可读性+可移植性+无需编译+无需内存管理。

运行速度可能会慢些，但是导致瓶颈的模块在后期可以替换成C++。

相信开发过游戏的同志们都会被长时间的编译所折磨过吧？使用Python虽然比纯C++的运行速度要慢，但是带来的开发速度是不可小觑的。


### 安装


OGRE的Python包装在 [http://sourceforge.net/projects/python-ogre/files/Latest/](http://sourceforge.net/projects/python-ogre/files/Latest/) 下载。教程在这里 [http://wiki.python-ogre.org/index.php/SettingUpAnApplication](http://wiki.python-ogre.org/index.php/SettingUpAnApplication) 。

最新版的可以从SVN中下载：


> svn co https://python-ogre.svn.sourceforge.net/svnroot/python-ogre python-ogre


安装过程非常的简单：

首先安装Python，我装的是2.7.

然后下载好OGRE的Python包装，解压。

然后在命令行下输入 python setup.py install。

如果有什么疑问可以去看下 [http://www.cse.unr.edu/~sushil/class/381/ware/pythonOgreWin7Install.pdf](http://www.cse.unr.edu/~sushil/class/381/ware/pythonOgreWin7Install.pdf)。

第一个程序：


{% codeblock python lang:python %}

import ogre.renderer.OGRE as ogre
import SampleFramework as sf

class TutorialApplication(sf.Application):

   def _createScene(self):
       pass

if __name__ == '__main__':
   ta = TutorialApplication()
   ta.go()


{% endcodeblock %}


其中SampleFramework.py可以从我们刚刚下载的OGRE的Python包装中复制出来。另外需要创建两个文件。


#### plugins.cfg




> 

{% codeblock %}
# Defines plugins to load

# Define plugin folder
PluginFolder=./plugins

# Define D3D rendering implementation plugin
Plugin=RenderSystem_GL.dll
Plugin=RenderSystem_Direct3D9.dll
Plugin=Plugin_ParticleFX.dll
Plugin=Plugin_BSPSceneManager.dll
Plugin=Plugin_OctreeSceneManager.dll
Plugin=Plugin_CgProgramManager.dll
{% endcodeblock %}






#### resources.cfg


里面留空就好。

此外，我们还需要把plugins目录复制过来。

然后就OK了。

[![image](http://www.everet.org/wp-content/uploads/2012/01/image_thumb3.png)](http://www.everet.org/wp-content/uploads/2012/01/image3.png)
