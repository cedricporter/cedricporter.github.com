---
comments: true
date: 2012-01-27 17:31:58
layout: post
slug: clover-progress
title: Clover进度
wordpress_id: 321
categories:
- 我的代码
tags:
- Clover
- OGRE
- Python
---

### 2012-3-30:


今天我们把视频提交了。也上传了一份。

[http://v.youku.com/v_show/id_XMzc0MTAyMDg0.html<!-- more -->](http://v.youku.com/v_show/id_XMzc0MTAyMDg0.html)


### 2012-3-19：


前几天各种生病，今天好多了，又要准备开工了...<!-- more -->


### 2012-3-13：


现在是凌晨1点18分，在FoldingUp的group排序似乎可以用了。下一步工作也基本可以开始了。

天气多变，很多人都生病了啊。

加油啊！


### 2012-3-12:


今天是植树节，其实平时也是完全没时间概念，只是看到Google的Logo才想起已经是12号了。

现在是16点37分，刚刚实现了动画，把解释器放到另一个线程，每执行一条重要的命令就会阻塞到动画做完。

现在准备做鼠标折纸，然后自动生成脚本文件。

我们已经进入第三行了啊~悲剧了啊~~

[![](http://everet.org/wp-content/uploads/2012/01/QQ截图20120312163717.png)<!-- more -->](http://everet.org/wp-content/uploads/2012/01/QQ截图20120312163717.png)


### 2012-3-11:


现在是11号凌晨0点53分，刚刚写完了Clover数据结构文件保存的文章，留个链接

[http://everet.org/2012/03/clover-save-file.html](http://everet.org/2012/03/clover-save-file.html)


### 2012-3-10:


今晚花了一晚就实现了文件的保存和读取，重建整个结构其实还是比想象中简单很多啊~~

现在是下午14:43，Todo List变成这样了。

[![](http://everet.org/wp-content/uploads/2012/01/IMG_0016.jpg)<!-- more -->](http://everet.org/wp-content/uploads/2012/01/IMG_0016.jpg)


### 2012-3-9：


加了4行就把CutFace的割两边的版本改造成支持所有情况了。

ShadowSystem的Undo和Redo基本可以用了，Revert还有点问题。

旭瑜貌似在帮另外一拨人做Android的界面，Group写了很久了。

师兄在实现鼠标拖那张纸。

今天屠文翔同学一起弄ShadowSystem，晚点屠文翔会弄多层纸的交互。<!-- more -->


### 2012-3-8:


11点多收到明天面试，本来还想接着写完ShadowSystem的，就临时拿本《算法导论》看看了，很久没翻过了。


### 2012-3-7:


现在是凌晨2点22分，我发现cut face在更新整个数据结构的时候还是会有所遗漏，明天再弄了。

发现问题出在我最引以为傲的2B算法上。

现在目前我们的工作总结：

屠文翔同学弄了FoldingUp和Bending两种模式的视觉效果了...

Group还没有顺序，这个问题很严重，会导致绘图的时候面的次序出错。旭瑜要加油啊。

师兄正在主要还是在解决一些复杂的数学问题....

<!-- more -->


### 2012-3-6:


想一下我们现在的TODO List：



	
  1. 将3维的纸张重新映射回2维的值，得到有折痕的纸。

	
  2. 将折痕变成提示折痕

	
  3. 脚本引擎的完善

	
  4. 自动贴合

	
  5. 避免面完全重叠

	
  6. 将折纸过程重放，需要深入理解这个数据结构才可以完成

	
  7. 保存文件

	
  8. 加载文件

	
  9. 换贴图




##### 对于脚本引擎的想法：








	
  * 虽然对于普通用户可能没什么用，但是脚本对于我们测试整个系统有着莫大的帮助。

	
  * 而且对于我们的技术分也有提高。

	
  * 臆想的效果是：进入脚本折叠模式后，弹出代码框和一个输出框（默认不显示，主要用于提示他的语法错误了），

	
  * 然后友好地弹出每个顶点的索引和位置，还需要尽量避免信息框互相遮挡。

	
  * 为了解决遮挡问题，我们可以鼠标点击某个顶点，会另外弹出一个特殊的框来显示顶点的信息。










--------------------------------------------------------


现在是北京时间凌晨4点22分，我终于折好了飞机，发现问题出在Face引用了历史中的Vertex。睡醒了再修正了。

[![](http://everet.org/wp-content/uploads/2012/01/QQ截图20120306042141.png)](http://everet.org/wp-content/uploads/2012/01/QQ截图20120306042141.png)

使用如下的脚本....很2B，需要改进


{% codeblock python lang:python %}

#
# 2B飞机 By ET
#

# 先在中间画条折线
edgeMiddle = Edge(Vertex(-50, 0, 0), Vertex(50, 0,0))
face = FindFacesByVertex(0)[0]
CutFace2(face, edgeMiddle)

for v1, v2, v3, sign in [(3, 0, 7, 1), (2, 1, 13, -1)]:
    # 左上角往回折
    edge = Edge(Vertex(50, sign * 10, 0), Vertex(10, sign * 50,0))
    face = FindFacesByVertex(v1)[0]
    CutFace2(face, edge)

    faces = FindFacesByVertex(v1)
    RotateFaces(faces, edge, 180)

    # 上面1/4反折
    edge = Edge(Vertex(-50, sign * 30, 0), Vertex(30, sign * 30,0))
    face = FindFacesByVertex(v2)[0]
    CutFace2(face, edge)

    edge = Edge(Vertex(10, sign * 30, 0), Vertex(30, sign * 30,0))
    face = FindFacesByVertex(v1)[0]
    CutFace2(face, edge)

    # 翅膀往回折
    faces = FindFacesByVertex(v3)
    RotateFaces(faces, edge, sign * 90)

# 对折
faces = FindFacesByVertex(16)
RotateFaces(faces, edgeMiddle, 180)


{% endcodeblock %}


大合照：

<!-- more -->

{% codeblock %}
 [![](http://everet.org/wp-content/uploads/2012/01/QQ截图20120306141134.png)](http://everet.org/wp-content/uploads/2012/01/QQ截图20120306141134.png)
{% endcodeblock %}



### 2012-3-5:


今天凌晨3点实现了割线过0个顶点的cut a face。可以使用脚本割面和折叠了。

[![](http://everet.org/wp-content/uploads/2012/01/未命名2.jpg)](http://everet.org/wp-content/uploads/2012/01/未命名2.jpg)

我们的提交日志，超长的图片:<!-- more -->

[![](http://everet.org/wp-content/uploads/2012/01/2012-03-05-16-16-07.png)](http://everet.org/wp-content/uploads/2012/01/2012-03-05-16-16-07.png)


### 2012-3-4:


刚刚花了2个小时加了脚本引擎，可以使用脚本来控制整个系统。哇哈哈~~~

原来这么简单啊....

屠文翔同学也做了进入折叠模式的特效。还有折叠时的半透明效果，相当的牛逼啊。

为了方便脚本控制折叠，我们将每个点都显示出来了。

[![](http://everet.org/wp-content/uploads/2012/01/QQ截图20120304205034.png)](http://everet.org/wp-content/uploads/2012/01/QQ截图20120304205034.png)


### <!-- more -->2012-3-3:


好久没有更新了，猛地发现已将近一个月都没更新了。

现在已经可以用代码折叠了....截个图留念一下...

[![](http://everet.org/wp-content/uploads/2012/01/QQ截图20120303215309.png)](http://everet.org/wp-content/uploads/2012/01/QQ截图20120303215309.png)


### <!-- more -->2012-2-6:


今天把面分割和折叠写了。

[![](http://everet.org/wp-content/uploads/2012/01/未命名1.jpg)](http://everet.org/wp-content/uploads/2012/01/未命名1.jpg)

[![](http://everet.org/wp-content/uploads/2012/01/21.jpg)](http://everet.org/wp-content/uploads/2012/01/21.jpg)

数据结构见：[http://www.everet.org/2012/02/clover-data-structure.html](http://www.everet.org/2012/02/clover-data-structure.html)


### 2012-2-1:


刚刚把我测试的分支里的main.py拆分开来了。


### 2012-1-31：


发现动手写代码还是需要看很多遍Tutorial，记下地址：[http://wiki.python-ogre.org/index.php/Basic_Tutorial_1](http://wiki.python-ogre.org/index.php/Basic_Tutorial_1)

**屠文翔同学的日志：[http://www.cnblogs.com/kidshusang/archive/2012/01/31/2333970.html](http://www.cnblogs.com/kidshusang/archive/2012/01/31/2333970.html) 转载过来存档。**


> 果然验证了简单的问题不简单，想要弄个导航立方体，遇到了各种各样的难题

首先是Ogre貌似并不能直接导入3ds模型，Ogre仅支持自己的.mesh格式的模型

所以我要通过一个叫做3ds2mesh的工具把我的立方体3ds转换成mesh

<!-- more -->

第二个难题是为立方体贴图

因为6个面标识着六个方向，所以要为六个不同的面贴不同的图

这就意味着我第一步的工作白费了！无法为一个现成的，空白的六面体贴图

这就意味着，要不我就用3dsMax把贴好图的立方体导出来，要不我就用代码生成一个立方体，并同时为每一个面定义贴图

我选择后者。（参考资料的传送门：[http://0flyingpig0.blog.163.com/blog/static/9937055620101209433665/](http://0flyingpig0.blog.163.com/blog/static/9937055620101209433665/)）

第三个难题是，Ogre管理Material（材质）的方法和Irrlicht真的是完全不一样

在Ogre里面，如果想要控制光照，反面裁剪，纹理贴图，就要自己新建一个Material，并给Entity赋予这个Material

而Irrlicht里面只用设个标志位就好了

我不能说哪种方法更好，不过看起来Irrlicht的方法更简单，而Ogre的方法更专业

另外，材质也是可以使用脚本的，脚本后缀名为.material

（脚本使用方法传送门：[http://www.ogre3d.org/docs/manual/manual_14.html#SEC23](http://www.ogre3d.org/docs/manual/manual_14.html#SEC23)）

（脚本教程传送门：[http://www.ogre3d.org/tikiwiki/MadMarx+Tutorial+7&structure=Tutorials](http://www.ogre3d.org/tikiwiki/MadMarx+Tutorial+7&structure=Tutorials)）

第四个难题揭示了我是多么的天真。

现在我已经弄好了六面体，并且把它摆在场景中央

[![](http://www.everet.org/wp-content/uploads/2012/01/r_未命名-1.jpg)](http://www.everet.org/wp-content/uploads/2012/01/r_未命名-1.jpg)

一切看起来正常，六面体的正面正对着我。

貌似此时需要做的只是写玩导航逻辑就大功告成，也就是说我拖动六面体，场景镜头就会转动

可是我觉得把一个导航块放在场景中间有些不合适，所以我决定把它放在旁边

尼玛啊……

它在逻辑上是朝向这正面，但是由于视角问题，变得好像不是朝向正面

解决方法我先在想到的有两种

第一种是让它倾斜一个角度朝向我，并把这个方向当做是初始方向，以后的旋转镜头都加上这个偏移量

第二种是将这个六面体渲染成一张texture（RTT）并贴出来

我先试试看第一种方法……

[![](http://www.everet.org/wp-content/uploads/2012/01/r_未命名-2.jpg)](http://www.everet.org/wp-content/uploads/2012/01/r_未命名-2.jpg)

另外，Ogre管理资源的方法真的是非常的诡异，有空我要好好看看这篇东西[http://www.ogre3d.org/tikiwiki/Resources+and+ResourceManagers&structure=Tutorials](http://www.ogre3d.org/tikiwiki/Resources+and+ResourceManagers&structure=Tutorials)


**屠文翔同学的日志：[http://www.cnblogs.com/kidshusang/archive/2012/01/31/2332526.html](http://www.cnblogs.com/kidshusang/archive/2012/01/31/2332526.html) 转载过来存档。**


> 啊，这一晃眼十多天就过去了

今天天气转暖了，是个开始工作的好日子

前两天亮哥提议我们使用Python加速开发，也就是使用PythonOgre，是个不错的建议

于是前两天装了PythonOgre，看了看教程和例子，发现PythonOgre里面已经集成了CEGUI，好吧真方便

（顺便吐槽一下，这几天习惯了使用VIM，突然有点不习惯普通的文本编辑方式）

今天开了小组会议，会议中我们把Clover逻辑层面的数据结构给讨论了一下

会议记录传送门：[http://www.everet.org/2012/01/clover-architecture-design-meeting.html](http://www.everet.org/2012/01/clover-architecture-design-meeting.html)

（密码什么的我会随便乱说么）

<!-- more -->

回顾一下今天我做的事

因为vim，python和pythonOgre我一个都不熟，所以花费在熟悉他们上面的时间比干正事的时间多得多

不过总算我理清了python是如何处理类，模块和集成的了

之前帮骨架系统装上界面后，CEGUI把所有键盘和鼠标消息都截断了

于是亮哥抱怨无法“围观”他的作品，只好自己开个无界面版的分支

我自己也开了个分支，尝试解决这个问题

不过在经过研究Ogre.Renderer.Ogre.sf_ois模块中的代码和一些尝试以后，我发现这个问题还真不太好解决（也可能是我没太明白它的消息处理机制），而且也没什么必要去解决（因为我们的软件必然不是用WASD来移动照相机……）

我决定明天开始研究如何完全使用鼠标来移动视角

计划下明天要做的事

首先，纯用鼠标移动视角是件很简单的事情

可是按照一般事情的尿性来看，简单的事情都没有想象中那么简单

一个矛盾点就是，如果通过在屏幕上拖动鼠标来移动视角，那么界面就废了……

所以我的想法是参考3dsMax的做法，在屏幕上放一个指示方向的六面体骰子，通过拖动这个骰子来改变视角

这个骰子不可能是CEGUI，只能是3D场景中的一部分

所以我的工作可以归纳为一下几个：

1.找一个六面体模型，并弄好标有上下左右前后的纹理，导入PythonOgre

2.研究下鼠标如何和这个六面体交互，需要用到拾取吗？

3.研究下鼠标的事件机制

4.研究下摄像机，因为摄像机有两种移动方式，一种是自己动，一种是跟着节点动

亮哥工作日志的传送门：[http://www.everet.org/2012/01/clover-progress.html](http://www.everet.org/2012/01/clover-progress.html)




### 2012-1-30：




> 架构设计会议记录：[http://www.everet.org/2012/01/clover-architecture-design-meeting.html](http://www.everet.org/2012/01/clover-architecture-design-meeting.html)

选用Triangle List来画三角形，虽然比strip更耗空间，不过方便建模。一个三角形就是三个点，初步是按顺时针和逆时针把两个面画了。日后再改了，反面裁剪的开关我也没去找在哪里。

TODO：

> 
> 
	
>   1. 点的拾取和边的拾取。可能要自己写算法拾取，也可能有现成的解决方案。关键得有人去解决这个问题。
> 
	
>   2. 动态添加点。这个怎么弄？首先得定位在哪里添加，是打散三角形还是怎样。还是说本来就很多点，这样方便使用物理引擎模拟纸张的弯曲。
> 
	
>   3. 光照材质这些外观的东西先忽略...<!-- more -->
> 






### 2012-1-29:




> 师兄把Python-Ogre装了。




### 2012-1-28：




> 屠文翔把界面框架写了。

自定义几何体 [http://www.ogre3d.org/tikiwiki/ManualObject](http://www.ogre3d.org/tikiwiki/ManualObject)




### 2012-1-27:




> 开工，预期使用Python编码，Git管理。<!-- more -->

进度记录：[http://www.everet.org/2012/01/clover-progress.html](http://www.everet.org/2012/01/clover-progress.html)

网页浏览版本库： [http://git.everet.org/](http://git.everet.org/)


屠文翔的通知：


> 

> 
> 各位新年好啊
> 
> 

> 
> 春节期间走亲访友外加同学聚会唱k陪女朋友很辛苦吧？
> 
> 

> 
> 现在有个好消息，你们解脱了，因为要开始工作了！<!-- more -->
> 
> 

> 
> 

> 
> 首先回顾一下我们要做什么
> 
> 

> 
> 在2月29日之前提交文档(见附件)
> 
> 

> 
> 

> 
> 然后回顾一下之前我们做了些什么
> 
> 

> 
> 定下来了大方向和技术框架
> 
> 

> 
> 图像引擎使用OGRE
> 
> 

> 
> 界面UI使用CEGUI
> 
> 

> 
> 物理引擎使用Newton
> 
> 

> 
> 骨架系统的一些需求见需求文档（附件2）
> 
> 

> 
> 另外还有就是，华亮和我都已经弄好了OGRE环境，华亮还弄好了PythonOgre的环境，我这边还弄好了CEGUI的环境
> 
> 

> 
> 

> 
> 

> 
> 接下来一周内要做的工作
> 
> 

> 
> 首先徐小孟同学要开始配置和熟悉OGRE环境，以及
> 
> 

> 
> 这里是OgreSDK的下载地址，下载1.7.4  [http://www.ogre3d.org/download/sdk](http://www.ogre3d.org/download/sdk)
> 
> 

> 
> 这里是Ogre安装教程 [http://www.ogre3d.org/tikiwiki/Installing+the+Ogre+SDK](http://www.ogre3d.org/tikiwiki/Installing+the+Ogre+SDK)
> 
> 

> 
> 这里是Ogre基础教程 [http://www.ogre3d.org/tikiwiki/Tutorials](http://www.ogre3d.org/tikiwiki/Tutorials)
> 
> 

> 
> 华亮强烈建议我们使用PythonOgre进行开发，PythonOgre是使用Python语言重新封装的Ogre的一个库，使用PythonOgre最大的好处就是不需要编译
> 
> 

> 
> 这里是PythonOgre安装及使用的一些简单教程 [http://www.everet.org/2012/01/python-ogre-start.html](http://www.everet.org/2012/01/python-ogre-start.html)
> 
> 

> 
> 华亮还强烈建议这次我们要做到文档完善，结构清晰，注释充分，架构健壮……
> 
> 

> 
> 所以华亮这一周的工作是弄个架构设计文档出来，最好把骨架系统也搭起来。如果遇到需要和大家商量的地方可以在qq上商量。
> 
> 

> 
> 对于我，杨旭瑜和徐小孟，这一周的共同工作则是，安装PythonOgre（对于徐小孟同学，你还要安装原版的OgreSDK），研究Ogre的例子和源码，学习Ogre的设计架构（听说徐小孟同学在写自己的渲染引擎，这点可能对你比较有帮助）；学习Ogre的功能，并留意其中对我们以后的开发用的上的功能。
> 
> 

> 
> 另外，虽然是华亮负责架构，但并不意味这我们可以不用去了解。因为我们是基于Ogre开发，所以可以预见到我们的软件架构和Ogre自身的架构是有许多相似之处的。我建议大家多去关注一下Ogre里面用到的设计模式，如单例模式，工厂模式，这对我们自己以后的发展也很有帮助。
> 
> 

> 
> 

> 
> 

> 
> 以上！
> 
> 

> 
> 屠文翔
