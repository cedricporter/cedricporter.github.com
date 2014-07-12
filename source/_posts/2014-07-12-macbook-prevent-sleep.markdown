---
layout: post
title: "解决有时Macbook盒盖后不会睡眠的问题"
date: 2014-07-12 10:32
comments: true
categories: IT
tags: [Mac]
---
很久以前，就听到许多人说，用Macbook都是从来不关机，平时都是直接盖上盖子塞到包里。于是我也这样了，不过后来突然发现，塞到包里第二天早上起来开机的时候，就发现Macbook已经关机了。重新开机的时候，就提示系统没有正常关机。

晚上有时候回到家里，将Macbook拿出来，就发现温度非常高。看上去合上盖子后，并没有sleep。

想起很久之前，我都是直接合上盖子就走，不过后来突然就出现了合上盖子塞包里后，过热关机。这个是为什么呢？难道是我升级系统后，系统出了什么bug?

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

看来就是估计我每天听douban.fm惹的祸。

于是继续尝试在chrome里面随便打开一个视频网站看视频，发现此时`PreventUserIdleSystemSleep`又变成1了。

看来应该只要有会播放声音的flash在，就会阻止Macbook睡眠。找到问题了唉，看来以后小心为妙。




