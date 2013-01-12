---
layout: post
title: "[学习HTTP] Transfer-Encoding: chunked"
date: 2013-01-11 15:43
comments: true
categories: IT
tags: [HTTP]
---

在HTTP/1.1中，如果需要保持连接的话，那么Content-Length是必须要提供的。否则就无法确定此次请求的结束位置。

但是，如果我们要在*动态生成的过程中*就想发送数据，是无法预先知道报文的长度的，所以也就不可能使用Content-Length来指明body长度。那为啥要边生成边发送呢？假设生成完整数据需要30秒，如果要生成完再发送的话，那么就浪费了这30秒的美好的传输时间了。chunked就解决了这个难题，只要服务器允许将body逐块发送，并说明每块的大小就可以了。

**那如何边生成边发送呢？**

我们可以通过将Transfer-Encoding指定为chunked，来进行分块传输。我们就可以将原本一整块需要说明长度的数据分解成了一小块一小块需要说明长度的数据。就可以边生成边发送了。

<!-- more -->

Chunked Transfer Coding在rfc2616 [^1] 中的文法定义如下：

``` ini 
Chunked-Body   = *chunk
                 last-chunk
                 trailer
                 CRLF
chunk          = chunk-size [ chunk-extension ] CRLF
                 chunk-data CRLF
chunk-size     = 1*HEX
last-chunk     = 1*("0") [ chunk-extension ] CRLF
chunk-extension= *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
chunk-ext-name = token
chunk-ext-val  = token | quoted-string
chunk-data     = chunk-size(OCTET)
trailer        = *(entity-header CRLF)
```

对于每一个chunk，由chunk-size开头，这个是一个**16进制**数字的字符串，用来表示后面将有多长的数据。然后跟着的是数据。这里chunk-size和Content-Length的作用是相似的。最后结束的chunk的chunk-size为`0`。Chunk可以理解成类似这样的结构体，size指明data的长度:

``` c
struct Chunk
{
    int size;
    char *data;
};
```
    

## 测试

我们用nc[^2]作为服务器，看看浏览器的反应如何。通过nc，我们可以直接构造响应。

用nc监听本地8888端口，然后用浏览器访问本地8888端口，然后就可以看到浏览器发来的请求报文（2-11行）。然后我们模仿服务器发回响应（12-22行）。

``` console 使用nc扮演服务器 
$ nc -lp 8888
GET / HTTP/1.1
Host: localhost:8888
Connection: keep-alive
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.52 Safari/537.17
Accept-Encoding: gzip,deflate,sdch
Accept-Language: zh,zh-CN;q=0.8,en-US;q=0.6,en;q=0.4
Accept-Charset: UTF-8,*;q=0.5

HTTP/1.1 200 OK
Connection: close
Transfer-Encoding: chunked

A
This is Ev  
9
erET.org.
0

```

可以看到，Chunked-Body的内容分为一块一块的，最后以`0`结束。

{% graphviz %}
digraph G {
  node[shape = box];
  
  header -> chunk1 -> chunk2 -> chunk3;
  
  {
          edge[arrowhead = none];
          
          header -> text_header;
          chunk1 -> text_c1;
          chunk2 -> text_c2;
          chunk3 -> text_c3;
  }
  
  text_header[label = "HTTP/1.1 200 OK<CRLF>\lConnection: close<CRLF>\lTransfer-Encoding: chunked<CRLF><CRLF>", shape = note];
  text_c1[label = "A<CRLF>\lThis is Ev<CRLF>", shape = note];
  text_c2[label = "9<CRLF>\levET.org.<CRLF>", shape = note];
  text_c3[label = "0<CRLF><CRLF>", shape = note];
  
  {rank=same header text_header}
  {rank=same chunk1 text_c1}
  {rank=same chunk2 text_c2}
  {rank=same chunk3 text_c3}
}
{% endgraphviz %}


最后，在浏览器可以看到的内容为`This is EverET.org.`。

(全文完）


[^1]: [Transfer Codings](http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 ) , [Chunked Transfer Coding](http://greenbytes.de/tech/webdav/draft-ietf-httpbis-p1-messaging-13.html#rfc.section.6.2.1)

[^2]: netcat，黑客工具中的瑞士军刀。
