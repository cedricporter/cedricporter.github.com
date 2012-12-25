---
comments: true
date: 2012-04-11 02:19:17
layout: post
slug: anti-hotlink
title: “反盗链”与反“反盗链”
wordpress_id: 884
categories:
- 我的代码
- 网络
tags:
- Web
---

现在很多大网站都有了图片反盗链，于是有时候在某些论坛或者博客就会遇到些“此图片仅限于…用户之间交流与沟通”的图片，这真是无法理喻。


## 反盗链


引用一段话：来自[http://www.ningoo.net/html/2007/get_away_from_photo_defense.html](http://www.ningoo.net/html/2007/get_away_from_photo_defense.html)


> 这里忍不住再次提起这茬，是在[豆瓣九点](http://9.douban.com/)看blog的时候，时不时冒出一副“此图片仅限于…用户之间交流与沟通”的图片出来，一个字，烦。不让看你干脆将所有的img直接过滤掉不显示就好了，还TMD放这么恶心的一个东西来刺激我的眼睛，要知道我眼睛本来就不太灵光，还好心脏不错，不然搞不好弄出人命官司。Blog和网页有啥区别？我想区别就在于我可以通过rss聚合阅读而不必要跑到blogger的网站上去吧。要是你输出的东西这不能看，那仅限于，那还搞个屁的rss。

图片防盗链，请离blog远点。呼吁所有的blogger，离图片防盗链的XX网站远点，不然，你们的内容再好，也只能敬而远之了。


这个我深有同感。

<!-- more -->

基本大部分网站的反盗链都是通过HTTP Headers里面的Referer属性来判断是否盗链。

如果Referer来源不是他们的网站，他们会直接返回一个意思类似“你盗我链”的图片，或者直接404。

有的网站还算有的人性，如果Referer为空的话，他们会放过这个请求。

像在Apache下，我们可以轻松用rewrite模块来实现图片的反盗链。


> RewriteEngine on
RewriteCond %{HTTP_REFERER} !^$
RewriteCond %{HTTP_REFERER} !^[http://(www\.)?EverET.org(/)?.*](http://(www\.)?EverET.org(/)?.*)$     [NC]
RewriteCond %{HTTP_REFERER} !^[http://(www\.)?EverET.org(/)?.*](http://(www\.)?EverET.org(/)?.*)$     [NC]
RewriteRule .*\.(gif|jpg|jpeg|bmp|png)$ [http://www.EverET.org/nohotlink.xjpg](http://www.EverET.org/nohotlink.xjpg) [R,NC]


也就是看看HTTP Headers中Referer是不是自己的网站，不是就返回一个nohotlinks.xjpg的图片。


## 反“反盗链”


下面我们来看看百度的图片。

页面源代码如下：

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb2.png)](http://everet.org/wp-content/uploads/2012/04/image2.png)

打开页面后会发现img标签的图片是一张“仅供XX交流的图片”， 而在iframe里面的img可以正确显示：

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb3.png)](http://everet.org/wp-content/uploads/2012/04/image3.png)

对于上面那张“该图片仅供XX用户交流使用”的HTTP请求的Headers如下图：

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb4.png)](http://everet.org/wp-content/uploads/2012/04/image4.png)

它直接返回了一个“仅供XX交流的”

对于下图显示出来的周总理的照片，它的请求如下，很明显可以看到少了Referer这个属性。[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb5.png)](http://everet.org/wp-content/uploads/2012/04/image5.png)


### 进化


现在，我们可以通过javascript来让图片显得更美观，我们将iframe的大小设置到和图片大小一致，然后去掉边框，于是就看不出图片是在一个iframe里面了。于是我们就可以看到我们敬爱的周总理而不是“仅供XX用户交流使用”。

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb6.png)](http://everet.org/wp-content/uploads/2012/04/image6.png)

页面源码：

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb7.png)](http://everet.org/wp-content/uploads/2012/04/image7.png)

hotlink_under_id这个函数可以将在某个id的标签下的所有的图片自动变成iframe，实现突破允许referer为空的反盗链。

javascript代码：


{% codeblock javascript lang:javascript %}

var count = 0;
window.img_array = new Array();

// create a img frame
function create_img_iframe(url)
{
    var frameid = 'frameimg' + Math.random();
    window.img = '<img id="img" src=\''+url+'?'+Math.random()+'\' /><script>window.onload = function() { parent.document.getElementById(\''+frameid+'\').height = document.getElementById(\'img\').height+\'px\'; }<'+'/script>';
    window.img_array[count] = window.img;
    ifr = document.createElement('iframe');
    ifr.src = "javascript:parent.img_array[" + count + "];";
    ifr.frameBorder="0";
    ifr.scrolling="no";
    ifr.width="100%";
    ifr.id = frameid;

    count++;
    return ifr;
}

// hotlink, param id is the img parent id
function hotlink_under_id(id)
{
    var div = document.getElementById(id);
    imgs = div.getElementsByTagName('img');

    while (imgs.length > 0)
    { 
        src = imgs[0].src;
        ifr = create_img_iframe(src);
        imgs[0].parentNode.replaceChild(ifr, imgs[0]);
    }
}


{% endcodeblock %}


我们来看另一个网站的反盗链。它同样也是

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb.png)](http://everet.org/wp-content/uploads/2012/04/image.png)

我们可以在[http://everet.org/2012/02/the-http-status-code.html](http://everet.org/2012/02/the-http-status-code.html)看到HTTP状态码是302Found：类似于301，但新的URL应该被视为临时性的替代，而不是永久性的。

而**301**是Moved Permanently。客户请求的文档在其他地方，新的URL在Location头中给出，浏览器应该自动地访问新的URL。

看报文是被Apache重定向了。

[![image](http://everet.org/wp-content/uploads/2012/04/image_thumb1.png)](http://everet.org/wp-content/uploads/2012/04/image1.png)
