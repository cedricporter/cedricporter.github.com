---
layout: post
title: "[学习HTTP] 206 Partial Content"
date: 2013-01-06 10:31
comments: true
categories: IT 
tags: [HTTP, curl]
---
俺在把博客放在Github后，除了发现Github的Web Server将Cache-Control设置为max-age=86400外，还发现一个有趣的地方。Chrome在对于MP3文件的访问，Github返回的都是`206 Partial Content`，后来发现，原来Chrome在请求MP3的时候，会在请求头带上`Range: bytes=0-`。

对于2xx的返回码，都是成功的，不过常见的基本都是200，206到时挺少见滴，于是俺决定看看206究竟有什么特别的地方。

rfc2616日：对于206的定义是请求**必须**包含`Range`头来标示我们想要的范围，于是这也就说明Chrome访问MP3的时候因为加了`Range`头，于是被返回了206。

我们来看一下下面的例子：用curl请求<http://everet.org/2013/01/chrome-edit-with-emacs.html>，返回`200 OK`，其中`Content-Length: 15845`。


``` bash
$ curl --head http://everet.org/2013/01/chrome-edit-with-emacs.html
HTTP/1.1 200 OK
Server: GitHub.com
Date: Sun, 06 Jan 2013 02:47:09 GMT
Content-Type: text/html
Content-Length: 15845
Last-Modified: Sat, 05 Jan 2013 10:30:34 GMT
Connection: keep-alive
Expires: Mon, 07 Jan 2013 02:47:09 GMT
Cache-Control: max-age=86400
Accept-Ranges: bytes
```

那根据rfc2616的说法，是不是加上`Range`后，Web Server就会返回`206 Partial Content`了呢？我们来通过telnet试一试：

<!-- more -->

``` bash
$ telnet everet.org www
Trying 204.232.175.78...
Connected to everet.org.
Escape character is '^]'.
GET /2013/01/chrome-edit-with-emacs.html HTTP/1.1
Host: everet.org
Range: bytes=0-100


HTTP/1.1 206 Partial Content
Server: GitHub.com
Date: Sun, 06 Jan 2013 03:20:05 GMT
Content-Type: text/html
Content-Length: 101
Last-Modified: Sat, 05 Jan 2013 10:30:34 GMT
Connection: keep-alive
Expires: Mon, 07 Jan 2013 03:20:05 GMT
Cache-Control: max-age=86400
Content-Range: bytes 0-100/15845


<!DOCTYPE html>
<!--[if IEMobile 7 ]><html class="no-js iem7"><![endif]-->
<!--[if lt IE 9]><html cl
```

可以看到，服务器返回了100个字节的字符。为了方便测试，我们使用curl来尝试分块下载。

``` bash
$ curl http://everet.org/2013/01/chrome-edit-with-emacs.html -o a.html
$ curl --header "Range: bytes=0-10000" http://everet.org/2013/01/chrome-edit-with-emacs.html -o p1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  100 10001  100 10001    0     0  13227      0 --:--:-- --:--:-- --:--:-- 20451
$ curl --header "Range: bytes=10001-" http://everet.org/2013/01/chrome-edit-with-emacs.html -o p2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  100  5844  100  5844    0     0   7778      0 --:--:-- --:--:-- --:--:-- 12175
$ cat p1 p2 > b.html
$ diff a.html b.html 
```

我们将原始页面下载回命名为a.html。然后通过增加`Range`这个header来下载`0-10000`为p1，以及`10001-`下载剩余部分为p2。然后合并p1、p2为b.html。通过`diff a.html b.html`发现a.html和b.html内容完全一样。

嗯，正如我们所想的那样，加上`Range`后可以下载指定部分的内容，相应地服务器会返回`206 Partial Content`。

## Range范围的例子
这个例子是rfc2616里面的，首先假定entity-body长度为10000。

- 获取前500个字节 (byte offsets 0-499, inclusive):  bytes=0-499
- 获取第二个500字节 (byte offsets 500-999, inclusive): bytes=500-999
- 获取最后500字节 (byte offsets 9500-9999, inclusive): bytes=-500
- 获取最后500字节 bytes=9500-
- 第一个和最后一个字节 (bytes 0 and 9999):  bytes=0-0,-1
- Several legal but not canonical specifications of the second 500
  bytes (byte offsets 500-999, inclusive):
   bytes=500-600,601-999
   bytes=500-700,601-999

## 总结
我们可以通过`Range`和`206 Partial Content`来分块获取一个大文件。在offset有效的时候，Web Server会返回206，否则会返回`416 Requested Range Not Satisfiable`。

## 扩展阅读
  * [Status Code Definitions](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)
  * [Range](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35)
