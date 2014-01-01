---
layout: post
title: "学习Android——环境搭建"
date: 2014-01-01 17:09
comments: true
categories: IT
tags: Android
toc: true
---

年底了，部门里面开始了移动端开发的培训，有ios和Android的选，不过我这个屌丝没有mac，而且也挺喜欢Android的，所以就毫不犹豫地选择了Android。

我的一直都在用Ubuntu，Linux菜鸟用户。所以就在Ubuntu上面开发了，不过这个也让我遇到了一个诡异的问题，在后面再说了。


## Android SDK

<!-- more -->

最开始当然是下载Android开发的sdk，直接去[官网](http://developer.android.com/sdk/index.html#download)下载就好了，如果平时没有用Eclipse，可以下载ADT bundle，里面出了SDK外还自带了一个Eclipse以及相关的插件。

## Java
在此之前，当然需要安装Java，虽然可以`apt-get install openjdk7-jre`就装好了Java，不过还是建议安装Oracle Java，这个之前在玩minecraft的时候，就感受过两者的速度差异。

至于如何安装Oracle Java，可以参看这篇文章：[Linux 下安装配置 JDK7](http://dawndiy.com/archives/155/)。

## 下载sdk
我们可以打开`sdk/tools/android`这个，然后就打开了Android SDK Manager，在这里我们可以下载我们需要的sdk。

{% img /imgs/snapshot7_20140101_185035_3055ShH.png %}

## 模拟器加速

### x86 img

为了加速模拟器，非常建议下载`Intel x86 Atom System Image`，这个在Intel的CPU上面运行模拟器的速度会大大提高，这个是大牛[宇哥](https://github.com/cosmoslx)推荐的，本来用`ARM EABI v7a System Image`挺卡的，公司的电脑开个机也要挺久的，现在用Atom仅仅需要不到10秒就可以打开一个4.2的模拟器进到桌面，运行也非常流畅。

### kvm
另外，[宇哥](https://github.com/cosmoslx)说如果CPU支持虚拟化技术，打开可以提高性能，一般主板默认会关闭，需要在BIOS打开。

打开CPU虚拟化后kvm就可以工作了，可以提高一定的性能。可以`lsmod`看看kvm有没有工作。

``` console
➜  ~  % sudo lsmod | grep kvm
kvm_intel             132891  0
kvm                   443165  1 kvm_intel
```

不过我的笔记本的渣渣CPU(Intel® Core™2 Duo Processor P7350)就不支持VT，于是开机还是挺慢的，不过还是比ARM开个`8分57秒`好多了。用x86的镜像仅仅`1分30秒`就可以开完机了。

### gpu
我们在创建avd的时候，可以选上`Use Host GPU`，这样就可以有一定的加速。不过`snapshot`不可以和`Use Host GPU`同时使用，还是挺可惜的。

两者的区别可以看[What is Snapshot and Use host GPU emulation option(s) for?](http://android.stackexchange.com/questions/51739/what-is-snapshot-and-use-host-gpu-emulation-options-for)

## Linux下面的bug

Android课程的老师分享说在Linux下面有个Bug，会导致CPU 100%。我们可以在`~/.android/avd/[avdname].ini`加上`hw.audioOutput=no`，就可以解决CPU 100%的问题了。

## kubuntu上面遇到的问题

### adb
我在kubuntu 13.10 x64上面打开adb，直接报“No such file or directory” trying to execute linux binary，想起来之前有遇到过类似的问题，宇哥告诉我是因为缺了些so，一般情况都是64位系统里面缺了32位的一些库。

本来想安装`ia32-libs`，不过发现这个在ubuntu 13.10居然去掉了，不过还是有解决方案的[^1]。

``` console
sudo apt-get install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5
sudo apt-get install lib32z1
```

### Eclipse Crash
接着运行Eclipse，就一直crash，报的是

```
JVM segfaults; error log file contains

# Problematic frame:
# C [libgobject-2.0.so.0+0x19838] g_object_get_qdata+0x18
```
 
无论我用openjdk还是oracle java，都会crash，后来去找了发现原来是gtk的bug。暂时用下面的方法打开Eclipse就好了，具体见[^2]。

```
$ GTK2_RC_FILES=/usr/share/themes/Raleigh/gtk-2.0/gtkrc ~/android/adt-bundle-linux-x86_64-20131030/eclipse/eclipse
```

### SDL
终于开了Eclipse后，启动模拟器报：`SDL init failure, reason is: No available video device`。

发现又缺了个32位的库，`sudo apt-get install libsdl1.2debian:i386`装上[^3]。

## 无线adb
宇哥又介绍了一种无线adb，在手机安装[ADB Konnect (wireless ADB)](https://play.google.com/store/apps/details?id=com.rockolabs.adbkonnect)，然后按照程序的提示用adb连接上手机就可以远程无线调试了。


[^1]: [Fix Android adb on Ubuntu 13.10 64bit](http://mem0ryleak.tumblr.com/post/64617476512/fix-android-adb-on-ubuntu-13-10-64bit)

[^2]: [fatal error on eclipse Problematic frame: C [libgobject-2.0.so.0+0x19528] g_object_get_qdata+0x18](https://bugs.launchpad.net/ubuntu/+source/openjdk-7/+bug/1241532)

[^3]: [SDL init failure, reason is: No available video device](http://stackoverflow.com/questions/4841908/sdl-init-failure-reason-is-no-available-video-device)
