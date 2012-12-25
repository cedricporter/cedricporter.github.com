---
comments: true
date: 2012-01-27 15:30:39
layout: post
slug: tortoisegit-access-gitosis
title: TortoiseGit访问Gitosis搭建的版本库
wordpress_id: 317
categories:
- IT
tags:
- Git
- TortoiseGit
---

首先，我们创建好公钥和密钥，如何创建可以参考 [http://everet.org/2012/01/management-remote-host.html](http://everet.org/2012/01/management-remote-host.html) 。

然后把公钥id_rsa.pub发给Git版本库的管理员。

因为TortoiseGit使用ppk，所以我们需要用自己密钥重新创建一个ppk的密钥

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb6.png)](http://everet.org/wp-content/uploads/2012/01/image6.png)

我们首先打开 TortoiseGit 下的 puttygen，然后点击load，把自己密钥加载进来，我们之前创建的密钥，如果没做任何更改，则文件名为id_rsa。

<!-- more -->



[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb7.png)](http://everet.org/wp-content/uploads/2012/01/image7.png)

然后选中我们的密钥id_rsa。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb8.png)](http://everet.org/wp-content/uploads/2012/01/image8.png)

然后就有

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb9.png)](http://everet.org/wp-content/uploads/2012/01/image9.png)

然后我们保存新的ppk的密钥。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb10.png)](http://everet.org/wp-content/uploads/2012/01/image10.png)

接着，我们装载我们的密钥，我们打开Pageant。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb11.png)](http://everet.org/wp-content/uploads/2012/01/image11.png)

选择 Add Key。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb12.png)](http://everet.org/wp-content/uploads/2012/01/image12.png)

在弹出的浏览框中选择我们刚刚生成的ppk扩展名的密钥。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb13.png)](http://everet.org/wp-content/uploads/2012/01/image13.png)

然后就OK了。

[![image](http://everet.org/wp-content/uploads/2012/01/image_thumb14.png)](http://everet.org/wp-content/uploads/2012/01/image14.png)



2012年2月26日补充：

Git克隆版本库：

**加载密钥：**

[![](http://everet.org/wp-content/uploads/2012/01/11.png)](http://everet.org/wp-content/uploads/2012/01/11.png)



[![](http://everet.org/wp-content/uploads/2012/01/22.png)](http://everet.org/wp-content/uploads/2012/01/22.png)

OK

[![](http://everet.org/wp-content/uploads/2012/01/33.png)](http://everet.org/wp-content/uploads/2012/01/33.png)
