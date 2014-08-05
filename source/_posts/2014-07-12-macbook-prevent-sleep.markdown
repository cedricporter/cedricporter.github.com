---
layout: post
title: "解决Macbook盖上屏幕后不会睡眠"
date: 2014-07-12 10:32
comments: true
categories: IT
tags: [Mac]
---
很久以前，就听到许多人说，用Macbook都是从来不关机，平时都是直接合上屏幕塞到包里。于是我也这样了，不过后来突然发现，塞到包里第二天早上起来开机的时候，就发现Macbook已经关机了。重新开机的时候，就提示系统没有正常关机。

晚上有时候回到家里，将Macbook拿出来，就发现温度非常高。看上去合上盖子后，并没有sleep。

想起很久之前，我都是直接合上屏幕就走，不过后来突然就出现了合上屏幕塞包里后，过热关机。这个是为什么呢？难道是我升级系统后，系统出了什么bug?

<!-- more -->

这个问题我纠结了挺久的，问了其他人，都没有同样的问题，于是以为是我的硬件出了问题。隔了很久，终于找到了问题所在。

有时候，我用pmset的输出是：

``` bash
@  ~  % pmset -g
Active Profiles:
Battery Power           -1*
AC Power                -1
Currently in use:
 standbydelay         10800
 standby              1
 halfdim              1
 hibernatefile        /var/vm/sleepimage
 darkwakes            0
 disksleep            10
 sleep                1
 autopoweroffdelay    14400
 hibernatemode        3
 autopoweroff         1
 ttyskeepawake        1
 displaysleep         2
 acwake               0
 lidwake              1
```

有时候，输出是这样，可以看到`sleep`那行`(sleep prevented by coreaudiod)`。也就是coreaudiod阻止sleep。

``` bash
@  ~  % pmset -g
Active Profiles:
Battery Power           -1*
AC Power                -1
Currently in use:
 standbydelay         10800
 standby              1
 halfdim              1
 hibernatefile        /var/vm/sleepimage
 darkwakes            0
 disksleep            10
 sleep                1 (sleep prevented by coreaudiod)
 autopoweroffdelay    14400
 hibernatemode        3
 autopoweroff         1
 ttyskeepawake        1
 displaysleep         2
 acwake               0
 lidwake              1
```

然后看看assertion，这个时候，`PreventUserIdleSystemSleep`这个为1，就是不会sleep了。

``` bash
@  ~  % pmset -g assertions
14-7-12 GMT+811:19:57
Assertion status system-wide:
   BackgroundTask                 0
   PreventDiskIdle                0
   ApplePushServiceTask           0
   UserIsActive                   1
   PreventUserIdleDisplaySleep    0
   InteractivePushServiceTask     0
   PreventSystemSleep             0
   ExternalMedia                  0
   PreventUserIdleSystemSleep     1
   NetworkClientActive            0
Listed by owning process:
   pid 72(hidd): [0x0000000a000001b1] 01:08:21 UserIsActive named: "com.apple.iohideventsystem.queue.tickle"
        Timeout will fire in 91 secs Action=TimeoutActionRelease
   pid 323(coreaudiod): [0x0000000100000281] 00:04:07 NoIdleSleepAssertion named: "com.apple.audio.'AppleHDAEngineOutput:1B,0,1,1:0'.noidlesleep"
No kernel assertions.
```

于是看看什么程序用到声音，只有chrome里面开了douban.fm，不过此时没有在播放音乐。然后关闭douban.fm的tab，然后`PreventUserIdleSystemSleep`就变回0了。

<del>看来就是估计我每天听douban.fm惹的祸。</del>

<del>于是继续尝试在chrome里面随便打开一个视频网站看视频，发现此时`PreventUserIdleSystemSleep`又变成1了。</del>

<del>看来应该只要有会播放声音的flash在，就会阻止Macbook睡眠。</del>

<del>另外，想itune，GarageBand等程序开着的时候，也可能会阻止sleep。所以，以后盖屏幕前，先处理掉这些程序，以免发生意外，要不然过热多几次，不知道Macbook会不会就烧坏了-.-</del>

<del>找到问题了唉，看来以后小心为妙。</del>

------------

Update: 

2014-07-27 

后来发现，有时候打开虚拟机，`PreventSystemSleep`会变为1，此时合上屏幕后也不会睡眠。所以这个时候，最好还是把虚拟机关掉。

后来发现，即便是关掉了所有会阻止睡眠的程序，没插电而且确定已经睡眠，发现放一个晚上后，还是会自动开机而且会很热，而且掉了很多电。

在shell中输入`syslog -k Sender kernel -k Message Req Wake`，看到茫茫多的

```
Jul 24 03:29:00 Stupid-ET kernel[0] <Debug>: Wake reason: ?
```

就是每分钟都Wake一次。仔细看日志，每次都是 sleep 3个小时后，就会开始不停地Wake up，然后reason: ?。不知道为啥，可能Mac OS有bug。那么现在如何解决呢？

现在的主要问题就是：sleep 3个小时后，就不能再自动sleep了。3个小时 = 3600 * 3 = 10800秒。

我们在看pmset的时候，有行`standbydelay 10800`[^1]。看上去可能在尝试写hibernation image的时候出错，导致无法sleep。

```
standbydelay specifies the delay, in seconds, before writing the hibernation image to disk and powering off memory for Standby.
```

于是先将该值调大，调到7天`sudo pmset -a standbydelay 604800`，然后就不会醒来了。


[^1]: [Understanding and choosing between Mac sleep, standby or hibernate](http://www.garron.me/en/mac/macbook-hibernate-sleep-deep-standby.html)
