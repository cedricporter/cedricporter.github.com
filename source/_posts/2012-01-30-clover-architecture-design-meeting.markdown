---
comments: true
date: 2012-01-30 16:23:14
layout: post
slug: clover-architecture-design-meeting
title: Clover架构设计会议记录
wordpress_id: 424
categories:
- IT
tags:
- Clover
- OGRE
- Python
---










**消息记录**










消息分组:讨论组










消息对象:我怎么听见喘息声。。













日期: 2012-01-30












XellOs


15:09:13




[![UARF0O4MI_$6HXMIHAA]{98](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA98_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA98.jpg)












XellOs


15:10:46






额













XellOs


15:10:56






好吧<!-- more -->














15:11:04




[![EARXH%L@NMG6Q@Y4MSIY(YJ](http://everet.org/wp-content/uploads/2012/01/EARXHLNMG6QY4MSIYYJ_thumb.png)](http://everet.org/wp-content/uploads/2012/01/EARXHLNMG6QY4MSIYYJ.png)15:11:04
杨旭瑜<yangxuyu_fish@qq.com>中止了语音通话。












XellOs


15:11:08






那个顶点是做图单位













XellOs


15:11:16






粒子是力的运算单位













XellOs


15:11:18






不一样的













XellOs


15:11:30






一个粒子可以用多个顶点来做图













XellOs


15:11:37






恩 是的













XellOs


15:11:39






是这个意思













XellOs


15:11:47






就是说粒子只是一个单位而已













XellOs


15:11:58






顶点应该多过粒子的数目的啊













XellOs


15:12:16






顶点只是画图的啊













XellOs


15:12:46






是啊













XellOs


15:12:50






和做terrain差不多啊













XellOs


15:12:54






是那么多的啊













XellOs


15:12:55






很多的啊













XellOs


15:13:09






我们做n body都是30000个粒子了













XellOs


15:13:28






用bill board显示的













XellOs


15:13:33






就是30000啊！













XellOs


15:14:07






恩













XellOs


15:14:48






这样













XellOs


15:15:10






你想像粒子成为一张布上的支撑点













XellOs


15:15:34






然后你用一张布在只受到重力作用这样平铺在上面













XellOs


15:15:52






但是粒子中间的间隙是可以有多个顶点绘制的













XellOs


15:16:39




[![UARF0O4MI_$6HXMIHAA]{98](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA98_thumb1.jpg)](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA981.jpg)












XellOs


15:16:47






这个，我还没有考虑数据结构上的













屠文翔


15:16:50






我怎么听见喘息声。。













XellOs


15:16:50






我想想哈。。。













XellOs


15:16:57






我也听见了













XellOs


15:17:07




[![UARF0O4MI_$6HXMIHAA]{98](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA98_thumb2.jpg)](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA982.jpg)












XellOs


15:17:11






怎么可能













XellOs


15:17:14






不可能的













XellOs


15:17:18






我在很安静的小黑屋啊













XellOs


15:17:48






是的













XellOs


15:17:51






传下













XellOs


15:17:52






喘息啊













XellOs


15:17:57




[![}4U8}`MOI7D)}P5`2$Q92TC](http://everet.org/wp-content/uploads/2012/01/4U8MOI7DP52Q92TC_thumb.gif)](http://everet.org/wp-content/uploads/2012/01/4U8MOI7DP52Q92TC.gif)












XellOs


15:18:13






那个是用texture来存储的













XellOs


15:18:23






用texture导入给gpu算的













XellOs


15:18:30






粒子的信息













XellOs


15:18:48






你可以参见directx sdk里面的Nbody













XellOs


15:19:03






第一次导入，之后是gpu自己算的













XellOs


15:19:12






粒子系统运算两种













XellOs


15:19:26






一种是初始+变量，一种是实时变的













XellOs


15:19:47






我们这种肯定是实时的啊，也就是需要存储每一次的信息的













XellOs


15:19:55




[![{~NF`YZ@I7A9P9HQA0BK$SI](http://everet.org/wp-content/uploads/2012/01/NFYZI7A9P9HQA0BKSI_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/NFYZI7A9P9HQA0BKSI.jpg)












XellOs


15:20:01






好的













XellOs


15:20:04






好纠结













屠文翔


15:20:03




[![XN9XY`3P2OI$AVBS4IKR8MW](http://everet.org/wp-content/uploads/2012/01/XN9XY3P2OIAVBS4IKR8MW_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/XN9XY3P2OIAVBS4IKR8MW.jpg)












XellOs


15:20:25






恩，就是啊。。













XellOs


15:20:30






想想先。。













XellOs


15:20:49






可以先列个list













XellOs


15:20:59






就是对高层的需求













XellOs


15:21:07






然后再往下考虑













XellOs


15:21:12






就是说高层需要做到什么













屠文翔


15:21:26






点 边 面













屠文翔


15:21:39






鼠标选取













屠文翔


15:21:45






高亮













屠文翔


15:21:52






边  长度 信息













XellOs


15:22:18






第二个是存储量













XellOs


15:22:24






大慨有多大













XellOs


15:22:29






需不需要用的平衡树













XellOs


15:22:39






我压根就没说话啊













XellOs


15:22:41






- -#













XellOs


15:22:48






我micro都是关了的啊













XellOs


15:22:52




[![PGPK8}I(@%8YZ}E``$R5E)D](http://everet.org/wp-content/uploads/2012/01/PGPK8I8YZER5ED_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/PGPK8I8YZER5ED.jpg)












XellOs


15:23:13






就是你要考虑检索速度的啊













XellOs


15:24:03






恩，那上层你准备先用什么存呢？













XellOs


15:24:26






一个点一个对象？













XellOs


15:24:34






不太好













XellOs


15:24:36






这样觉得













XellOs


15:25:02






又不太好- -#













XellOs


15:25:04






再考虑下













XellOs


15:25:27






我是觉得用面好点













XellOs


15:25:38






恩













XellOs


15:25:48






这样给下层运算好些













XellOs


15:25:55






但是给下层渲染要好点













XellOs


15:26:59






你想想你点检索之后不是每三个点就需要渲染个面













XellOs


15:27:05






你要做cull













XellOs


15:27:33






是啊













XellOs


15:27:36






我就是说这样













XellOs


15:27:59




[![ZAYOD())T$)W(YLA4AMA[J6](http://everet.org/wp-content/uploads/2012/01/ZAYODTWYLA4AMAJ6_thumb.gif)](http://everet.org/wp-content/uploads/2012/01/ZAYODTWYLA4AMAJ6.gif)


有点乱













XellOs


15:28:01






缕一缕













XellOs


15:28:49






比如： 一张白纸，你的逻辑点是4个，折一次之后逻辑点是几个？













XellOs


15:29:35






恩，对角折之后你4个点就需要存索引了













XellOs


15:29:50






如果不存索引你是不知道渲染哪几个面的了













XellOs


15:29:59






我用画图板画个图













XellOs


15:31:07




[![59%RG}BZRY5I1O]0X%PL9Z9](http://everet.org/wp-content/uploads/2012/01/59RGBZRY5I1O0XPL9Z9_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/59RGBZRY5I1O0XPL9Z9.jpg)












XellOs


15:31:34






如果你右边木有索引是木有办法画的













XellOs


15:31:50






怎么画呢？













XellOs


15:31:55






是啊













XellOs


15:32:03






存六个顶点你还是默认有索引了













XellOs


15:32:05






就是123456













XellOs


15:32:25






恩，这样也是可以的！













XellOs


15:32:36






那其实也就是存面了













XellOs


15:32:44






所以，回归了













XellOs


15:32:46






还是存面啊













XellOs


15:32:50




[![]~)Z$_L$~U]R%UQM{Q~_X)B](http://everet.org/wp-content/uploads/2012/01/Z_LURUQMQ_XB_thumb.gif)](http://everet.org/wp-content/uploads/2012/01/Z_LURUQMQ_XB.gif)












XellOs


15:33:27






我是觉得用树来存面就好了













XellOs


15:33:38






最上层的话













XellOs


15:33:42






逻辑面













XellOs


15:34:23






你逻辑面的三个点可以确定的啊













XellOs


15:34:40






是啊













XellOs


15:34:47






那个可以算出来的嘛













XellOs


15:34:57






直接算法就可以算的













XellOs


15:35:07






就是图上的123啊













XellOs


15:35:23






你还是用三角存啊













XellOs


15:35:31






两个就行了啊，刚才他说的













XellOs


15:35:56






做判断了哦













XellOs


15:36:01






算法来做了哦













XellOs


15:37:59






恩，这个数据结构我觉得再考虑下













XellOs


15:38:05






反正基本原理应该是那样的













XellOs


15:38:19






还是这个啊













XellOs


15:38:30






就是要考虑树的调整













XellOs


15:38:35






对













XellOs


15:38:38






就是节点的问题













XellOs


15:39:12






这个树不一定平衡吧













XellOs


15:39:26






恩，差不多













XellOs


15:39:39






不考虑一百个













XellOs


15:39:42






只考虑4个













XellOs


15:39:48






只考虑4个













XellOs


15:39:56






那一百个下去算













XellOs


15:40:08






2个三角形













XellOs


15:40:13






6个点













XellOs


15:40:19






两个树节点













XellOs


15:40:40






不的













XellOs


15:40:47






只有叶子表示面













XellOs


15:40:57






根不表示面的啊













XellOs


15:41:03






看来要用画图板了













XellOs


15:41:06




[![UARF0O4MI_$6HXMIHAA]{98[10]](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA9810_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA9810.jpg)












某花


15:41:27




[![FZ)L83KE~0M_OR457U3J}DT](http://everet.org/wp-content/uploads/2012/01/FZL83KE0M_OR457U3JDT_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/FZL83KE0M_OR457U3JDT.jpg)












某花


15:42:27




[![KZPJGW_U[B1AL4S_W(%$WZR](http://everet.org/wp-content/uploads/2012/01/KZPJGW_UB1AL4S_WWZR_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/KZPJGW_UB1AL4S_WWZR.jpg)












XellOs


15:42:27




[![K`DXBW[DPLF~SVDDWKD2[4M](http://everet.org/wp-content/uploads/2012/01/KDXBWDPLFSVDDWKD24M_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/KDXBWDPLFSVDDWKD24M.jpg)












XellOs


15:42:48






1和2写反了，不过不太影响













XellOs


15:42:54






只有叶子是面













XellOs


15:43:10






然后叶子中的三个点再交给下层去算图形学的顶点













XellOs


15:43:32






你定不了i













XellOs


15:43:33






太多了













XellOs


15:44:18






恩，我的意思是这样的













XellOs


15:44:29






那个你人不能算的啊













XellOs


15:44:30






茫茫多













某花


15:44:44




[![KZPJGW_U[B1AL4S_W(%$WZR[6]](http://everet.org/wp-content/uploads/2012/01/KZPJGW_UB1AL4S_WWZR6_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/KZPJGW_UB1AL4S_WWZR6.jpg)












XellOs


15:44:55






左边字是什么













XellOs


15:45:44






你的非叶子节点就是逻辑的面啊













XellOs


15:45:55






你的叶子就是逻辑的三角啊













XellOs


15:46:22






恩，是的













XellOs


15:46:25






但是不会很多啊













XellOs


15:46:44






你这个面有点难加













XellOs


15:46:47






应该要删点













XellOs


15:46:50






然后加点













XellOs


15:47:06






我是这样觉得的













某花


15:47:48




[![R2NR%XZ~9$}F{]WN_F2ME1L](http://everet.org/wp-content/uploads/2012/01/R2NRXZ9FWN_F2ME1L_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/R2NRXZ9FWN_F2ME1L.jpg)












XellOs


15:48:45




[![N)_VMYY4JDF$1X{ZP}KJ9JG](http://everet.org/wp-content/uploads/2012/01/N_VMYY4JDF1XZPKJ9JG_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/N_VMYY4JDF1XZPKJ9JG.jpg)












XellOs


15:49:00






因为你画图只会去找叶子，所以应该也快













XellOs


15:49:09






只是存储量可能比较大













XellOs


15:49:16






估计算是个空间换时间吧













XellOs


15:50:01




[![UARF0O4MI_$6HXMIHAA]{98[12]](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA9812_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/UARF0O4MI_6HXMIHAA9812.jpg)












XellOs


15:50:55






你那个我是觉得他不再是二叉树了













XellOs


15:51:07






什么不用加点？













屠文翔


15:51:30




[![1J9XT(ZGH17W5K[AGK~43WN](http://everet.org/wp-content/uploads/2012/01/1J9XTZGH17W5KAGK43WN_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/1J9XTZGH17W5KAGK43WN.jpg)












XellOs


15:51:45






是啊













XellOs


15:51:46






好专业啊













XellOs


15:51:51




[![{~NF`YZ@I7A9P9HQA0BK$SI[4]](http://everet.org/wp-content/uploads/2012/01/NFYZI7A9P9HQA0BKSI4_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/NFYZI7A9P9HQA0BKSI4.jpg)












屠文翔


15:52:25




[![UINX@6N1W{U76__}$`B%R0C](http://everet.org/wp-content/uploads/2012/01/UINX6N1WU76__BR0C_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/UINX6N1WU76__BR0C.jpg)












XellOs


15:52:58






首先是确定是最1的所有节点都有影响













XellOs


15:53:07






然后修正他的所有子节点













XellOs


15:53:15






所以3和4就必须分开













XellOs


15:53:33






恩，是的













XellOs


15:53:40






就是这个意思，加在3和4下面













XellOs


15:53:55






但是你会发现一个非三角的节点













XellOs


15:54:05






所以要单独处理，要进行费列













XellOs


15:54:07






分裂













XellOs


15:54:42






没有没有













XellOs


15:54:47






我的意思是叶子是三角













XellOs


15:54:54






其他是逻辑面













XellOs


15:55:30






画图困难啊













屠文翔


15:55:54




[![ZJET59XL~0K4E$A0DELFKNB](http://everet.org/wp-content/uploads/2012/01/ZJET59XL0K4EA0DELFKNB_thumb.jpg)](http://everet.org/wp-content/uploads/2012/01/ZJET59XL0K4EA0DELFKNB.jpg)












XellOs


15:56:05






差不多，很乱啊！













XellOs


15:56:17






要不再想想，这样树肯定比较大













XellOs


15:57:19




[![}4U8}`MOI7D)}P5`2$Q92TC[4]](http://everet.org/wp-content/uploads/2012/01/4U8MOI7DP52Q92TC4_thumb.gif)](http://everet.org/wp-content/uploads/2012/01/4U8MOI7DP52Q92TC4.gif)












XellOs


15:57:45






也行！













XellOs


15:58:00






然后下面再算是吧













XellOs


15:58:07






也行！













XellOs


15:58:24






对啊













XellOs


15:58:25






面啊













XellOs


15:59:06






感觉回退比较方便













XellOs


15:59:46






让它重复













XellOs


15:59:49






不要做索引













XellOs


15:59:52






太麻烦了













XellOs


16:00:15






恩，链表就好了













XellOs


16:00:18






反正不多













XellOs


16:00:44






先找面













XellOs


16:01:10






恩













XellOs


16:01:17






那个貌似要自己弄













XellOs


16:01:39






那个要查下













XellOs


16:01:45






拾取我也不太会













XellOs


16:02:06






八叉树插件？













某花


16:02:37






.ogre有没什么八叉树插件...













XellOs


16:02:43






不知道啊













XellOs


16:03:00






拾取算法应该比较多













XellOs


16:03:06






我回去查下书













XellOs


16:03:26






上层的方法要确定













XellOs


16:03:30






这个你还木有定哦













XellOs


16:03:48






就是逻辑操作什么的













屠文翔


16:04:04






拆面













屠文翔


16:04:07






拆分













XellOs


16:04:30






那些后来考虑吧













XellOs


16:04:33






先折吧













XellOs


16:04:38






不考虑拖先













XellOs


16:05:15






上层到下层就是用你数据结构中的顶点去算图元













XellOs


16:05:30






然后一起丢给gpu，让它画就可以了













XellOs


16:05:40






传个GPU的方法估计要用texture













XellOs


16:05:48






传给













XellOs


16:05:54






恩，然后给gpu













XellOs


16:06:02






但是这样没有用上gpu的运算能力













XellOs


16:06:07






恩，是的啊













XellOs


16:06:40






gpu和内存之间的数据交换方式有比较多种的













XellOs


16:06:51






用纹理传是一种













XellOs


16:06:58






恩，是的













XellOs


16:07:11






恩













XellOs


16:07:17






是的，是这个意思。













XellOs


16:07:56






有的，你可以参考下游戏编程那本书













XellOs


16:08:00






好像是第二本













XellOs


16:08:04






有个texture的管理器













XellOs


16:08:17






![]({E251FA83-4A93-42d3-9621-0704EA27D0D6}.dat)书在实验室，我忘记了













XellOs


16:08:33






是的，不过旭瑜快回去了













XellOs


16:08:36






他知道在哪













XellOs


16:08:51






那他去拿一下就好了













XellOs


16:08:53






他有钥匙













杨旭瑜


16:09:14






**我已经在实验室了的说。。。**













XellOs


16:09:20






用cpu算过













XellOs


16:09:24






木有用gpu算过













XellOs


16:09:34






恩













屠文翔


16:09:59






杨旭瑜没在语音上吧。。













杨旭瑜


16:10:10






**没有啊。**













某花


16:10:32






旭瑜，你装完了吗...














16:11:03






![]({7BF02F00-AB0E-4037-8DC1-3A915B181375}.dat)16:11:03
XellOs(636202)中止了语音通话。














16:11:04






![]({7BF02F00-AB0E-4037-8DC1-3A915B181375}.dat)16:11:04
主持人屠文翔(963262214)中止了语音通话，通话时长1小时2分18秒。













杨旭瑜


16:11:20






**我不清楚如何把git.everet.org的东西弄下来。**





