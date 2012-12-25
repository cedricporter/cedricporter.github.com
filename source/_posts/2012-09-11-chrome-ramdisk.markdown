---
comments: true
date: 2012-09-11 09:52:46
layout: post
slug: chrome-ramdisk
title: '[优化]将Chrome的数据放置到内存中去'
wordpress_id: 1400
categories:
- 技术类
tags:
- Linux
- Ubuntu
---

我现在使用的一台电脑的硬盘速度非常慢，Chrome有时也会对硬盘读写也会让机器发生顿卡，真是悲剧。所以我决定将Chrome经常读写的数据放置到内存中以提高响应速度。 Chrome的数据文件主要有用户配置文件以及磁盘缓存文件。在Ubuntu下就分别放置在~/.config/google-chrome以及~/.cache/google-chrome下面。 在Linux下，ramdisk直接就有了，直接拿来用就可以了，而在Windows下需要安装一些程序来创建ramdisk。我们来看看Linux下怎么做。 在Linux下，/dev/shm目录就是映射到了内存，所有写的东西都是直接写到了内存里面，不过这个目录不是持久的，断电就没了。


## Hack


我们的想法是，开机的时候将Chrome的数据文件全部放到/dev/shm下面，然后中间所有的读写都是在/dev/shm里面完成，因为都是在内存里面完成，所以速度会非常快。<!-- more --> 但是，坏处是，断电的时候，这个文件夹就会清空了。所以我们在关闭Chrome的时候，再将/dev/shm的数据复制到硬盘里面。这样的不足之处是，中间如果电脑突然断电会导致这次打开Chrome做的所有操作都没了，不过这不是大问题，因为只要是登录了的Chrome，都会将配置备份到Google的服务器，所以插件和收藏夹还是比较安全的。如果需要更安全，可以每隔一段时间（例如一两个小时），将/dev/shm的数据复制到硬盘，不过我觉得没什么必要，所以就不定期复制到硬盘。 嗯，那我们要处理的就两个文件夹：一个是用户数据文件夹**~/.config/google-chrome**，那些用户信息，历史记录都在里面；另一个是**~/.cache/google-chrome**，用来保存页面缓存文件。 这两个文件夹都可以通过启动参数设置位置，不过我为了全局性，就是无论从哪里打开chrome都可以享受ramdisk，所以我决定将这两个文件夹重定向到/dev/shm下面。


### 初始化，复制到内存


我们编写一个开机自启动的脚本。在Ubuntu下，我们可以在系统设置那里增加一个自启动。

{% codeblock bash lang:bash %}
#!/bin/bash

echo "Copies from disk to shm"
cp -rf /home/cedricporter/shm_backup/cedricporter /dev/shm/cedricporter 
chown cedricporter /dev/shm/cedricporter 

ln -s /dev/shm/cedricporter/.config/google-chrome ~/.config/google-chrome
ln -s /dev/shm/cedricporter/.cache/google-chrome ~/.cache/google-chrome

date >> /home/cedricporter/shm_backup/load.log
{% endcodeblock %}

这里做的是，将硬盘里面的Chrome数据文件复制到内存里面，然后建立文件夹链接。


### 关闭，写到硬盘


关闭Chrome后，写到硬盘。

{% codeblock bash lang:bash %}
#!/bin/bash

echo "save from shm to disk"
cp -rf /dev/shm/cedricporter /home/cedricporter/shm_backup

file=/home/cedricporter/shm_backup/save.log
echo "----- Start Saving -----" >> $file
date >> $file
echo "----- End -----" >> $file
{% endcodeblock %}



###  增加关闭Chrome时触发脚本


我们期望在关闭Chrome的时候，能够调用我们写到硬盘的脚本，来将/dev/shm里面的内容写到硬盘里面，好让下次开机的时候将数据载入到内存中。

我们可以看到我们平时快捷方式调用的Chrome为/opt/google/chrome/google-chrome。我们看一下这个文件，其实是一个shell文件。

其中最后一行为

{% codeblock bash lang:bash %}
exec -a "$0" "$HERE/chrome" "$@"
{% endcodeblock %}

我不想去修改这个shell文件，所以，我将其重命名为google-chrome.origin，然后新建一个shell文件，命名为google-chrome，内容如下：

{% codeblock bash lang:bash %}
#!/bin/bash

/opt/google/chrome/google-chrome.origin && /home/cedricporter/projects/chrome_cache/chrome_save_to_disk.sh
{% endcodeblock %}

也就是在执行完google-chrome.origin后执行我们的将内存中数据复制到硬盘的脚本。

好，搞定。

所有文件都在[https://github.com/cedricporter/chrome_cache](https://github.com/cedricporter/chrome_cache)，有兴趣同学可以去下载使用一下，不过需要修改一下脚本里面的路径名。
