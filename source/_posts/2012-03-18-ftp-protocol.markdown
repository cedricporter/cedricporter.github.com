---
comments: true
date: 2012-03-18 00:54:17
layout: post
slug: ftp-protocol
title: 'Mission: FTP Protocol'
wordpress_id: 738
categories:
- Web
tags:
- Web
---

FTP协议以前我用得挺少的，网络课上刘孜文老师曰FTP协议过时也就跳过了。不过现在FTP用得还是挺多的，所以决定围观下FTP。

刘孜文老师的经典名言是：我所学到的东西都不是从课堂上得来的。这点我挺赞同的。

刘孜文老师超强悍，中科院的博士，2个月看完了Linux内核的代码。

记得第一节课他说可以不用去上课，只要自己学就好了，于是偶深入贯彻刘老师的话，所以就一学期也没去上网络课了。

课下的时间都花在Scar上，网络也没仔细研究过，悲剧了，现在开始要好好补下才行了。


## 以下的内容是关于FTP协议的。


HTTP和FTP都是文件传输协议,他们都运行在TCP之上.

最显著的区别在于FTP使用两个并行的TCP连接,一个是控制连接(control connection),一个是数据连接(data connection).通常控制连接使用21端口.

因为FTP协议使用一个分离的控制连接,所以我们也称FTP的控制信息是带外(out-of-band)传送的。而HTTP协议在TCP连接中发送请求和响应首部行来控制，所以HTTP也可以说是带内（in-band)发送控制信息。

FTP服务器必须在整个会话中保存用户的状态信息，也就是说要保存用户的权限信息，远程目录树的当前位置。而HTTP协议则是无状态的，要通过cookie来保存用户状态。

<!-- more -->


### FTP协议的控制连接和数据连接如下图。


[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb.png)](http://everet.org/wp-content/uploads/2012/03/image.png)

FTP协议的定义：[http://www.w3.org/Protocols/rfc959/](http://www.w3.org/Protocols/rfc959/)

[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb1.png)](http://everet.org/wp-content/uploads/2012/03/image1.png)


## 两种模式


FTP协议的数据传输存在两种模式：主动模式( Active mode ) 和被动模式( Passive mode ) 。这两种模式发起连接的方向截然相反，主动模式是从服务器端向客户端发起；被动模式是客户端向服务器端发起连接。

如果采用被动模式，由于FTP服务器完全随机的选择一个端口，并告知客户，然后客户进行主动连接，这就意味着在服务器上，你要让所有的端口都允许动态入站连接才行，这样肯定不行，因为太危险了，等于打开了所有的端口连接。
如果采用主动模式（PORT Mode)，FTP服务器选择好端口后，主动与客户进行连接，这时候不需要像PASV模式那样打开所有的动态入站连接，而且正好相反，我们需要打开所有的动态出站连接即可，安全性增加很多。联机模式


### 主动模式 ( Active mode )


FTP Client 跟 FTP Server 联机后，会主动利用 PORT 指令提出 DATA Channel 联机的要求，如下：


> 指令: PORT 10,18,53,171,17,114

回应: 200 Port command successful.


这里的 PORT 指令是由 FTP Client 送出的，当需要建立 DATA Channel 时，FTP Server 会主动利用 Server 主机的 Port 20 发出联机到 FTP Client 的主机，而 PORT 指令后的参数说明如下：

前四个数字是 FTP Client 的 IP 地址：10.18.53.171

后两个数字是 FTP Client 接受联机的 Port 埠号，埠号的计算方式是 (第五个数字 * 256 + 第六个数字)，以此范例来说，FTP Client 接受的联机埠号是 17 * 256 + 114 = 4,466

由此可知，如果 FTP Client 处于 NAT 的环境下的话，FTP Server 几乎无法正常的联机到 FTP Client 的主机，所以现在大部分的联机模式几乎都建议用户使用被动模式(Passive mode)。


### 被动模式 ( Passive mode )


FTP Client 跟 FTP Server 联机后，会主动利用 PASV 指令提出 DATA Channel 联机的要求，如下：


> 指令: PASV

回应: 227 Entering Passive Mode (59,37,124,43,158,251)


你可以看到由 FTP Client 送出的 PASV 指令并没有送出其他的参数，而是在 FTP Server 响应的时候出现了 (59,37,124,43,158,251) 字符串，当需要建立 DATA Channel 时，这时就会由 FTP Client 主动连接至 FTP Server 动态开放的 Port 供 FTP Client 连接，其中 (59,37,124,43,158,251) 的说明如下：

前四个数字是 FTP Server 的 IP 地址：59.37.124.43

后两个数字是 FTP Server 接受联机的 Port 端口号，端口号的计算方式是 (第五个数字 * 256 + 第六个数字)，以此范例来说，FTP Server 可接受的联机端口号是 158 * 256 + 251 = 40,699

由此可知，使用被动模式(Passive mode)对 FTP Server 的系统管理员来说，可掌控的部分是比较多的，因为 FTP Server 无法决定用户是否可使用主动模式联机，但若改使用被动模式联机的话，就几乎能让所有人正常的使用 FTP 服务。


## 其他


FTP协议的命令和应答：[http://www.w3.org/Protocols/rfc959/4_FileTransfer.html](http://www.w3.org/Protocols/rfc959/4_FileTransfer.html)


### FTP COMMANDS [FTP命令]



{% codeblock %}
**USER** <SP> <username> <CRLF>
**PASS** <SP> <password> <CRLF>
**ACCT** <SP> <account-information> <CRLF>
**CWD**  <SP> <pathname> <CRLF>
**CDUP** <CRLF>
**SMNT** <SP> <pathname> <CRLF>
**QUIT** <CRLF>
**REIN** <CRLF>
**PORT** <SP> <host-port> <CRLF>
**PASV** <CRLF>
**TYPE** <SP> <type-code> <CRLF>
**STRU** <SP> <structure-code> <CRLF>
**MODE** <SP> <mode-code> <CRLF>
**RETR** <SP> <pathname> <CRLF>
**STOR** <SP> <pathname> <CRLF>
**STOU** <CRLF>
**APPE** <SP> <pathname> <CRLF>
**ALLO** <SP> <decimal-integer>
    [<SP> R <SP> <decimal-integer>] <CRLF>
**REST** <SP> <marker> <CRLF>
**RNFR** <SP> <pathname> <CRLF>
**RNTO** <SP> <pathname> <CRLF>
**ABOR** <CRLF>
**DELE** <SP> <pathname> <CRLF>
**RMD**  <SP> <pathname> <CRLF>
**MKD**  <SP> <pathname> <CRLF>
**PWD**  <CRLF>
**LIST** [<SP> <pathname>] <CRLF>
**NLST** [<SP> <pathname>] <CRLF>
**SITE** <SP> <string> <CRLF>
**SYST** <CRLF>
**STAT** [<SP> <pathname>] <CRLF>
**HELP** [<SP> <string>] <CRLF>
**NOOP** <CRLF>
{% endcodeblock %}



### Reply Code By Function Groups [返回码]



{% codeblock %}
**110** Restart marker reply.
    In this case, the text is exact and not left to the
    particular implementation; it must read:
         MARK yyyy = mmmm
    Where yyyy is User-process data stream marker, and mmmm
    server's equivalent marker (note the spaces between markers
    and "=").
**120** Service ready in nnn minutes.
**125** Data connection already open; transfer starting.
**150** File status okay; about to open data connection.
**200** Command okay.
**202** Command not implemented, superfluous at this site.
**211** System status, or system help reply.
**212** Directory status.
**213** File status.
**214** Help message.
    On how to use the server or the meaning of a particular
    non-standard command.  This reply is useful only to the
    human user.
**215** NAME system type.
    Where NAME is an official system name from the list in the
    Assigned Numbers document.
**220** Service ready for new user.
**221** Service closing control connection.
    Logged out if appropriate.
**225** Data connection open; no transfer in progress.
**226** Closing data connection.
    Requested file action successful (for example, file
    transfer or file abort).
**227** Entering Passive Mode (h1,h2,h3,h4,p1,p2).
**230** User logged in, proceed.
**250** Requested file action okay, completed.
**257** "PATHNAME" created.

**331** User name okay, need password.
**332** Need account for login.
**350** Requested file action pending further information.

**421** Service not available, closing control connection.
    This may be a reply to any command if the service knows it
    must shut down.
**425** Can't open data connection.
**426** Connection closed; transfer aborted.
**450** Requested file action not taken.
    File unavailable (e.g., file busy).
**451** Requested action aborted: local error in processing.
**452** Requested action not taken.
    Insufficient storage space in system.
**500** Syntax error, command unrecognized.
    This may include errors such as command line too long.
**501** Syntax error in parameters or arguments.
**502** Command not implemented.
**503** Bad sequence of commands.
**504** Command not implemented for that parameter.
**530** Not logged in.
**532** Need account for storing files.
**550** Requested action not taken.
    File unavailable (e.g., file not found, no access).
**551** Requested action aborted: page type unknown.
**552** Requested file action aborted.
    Exceeded storage allocation (for current directory or
    dataset).
**553** Requested action not taken.
    File name not allowed.
{% endcodeblock %}



### 文法


The syntax of the above argument fields (using BNF notation where applicable) is:

{% codeblock php lang:php %}

<username> ::= <string>
<password> ::= <string>
<account-information> ::= <string>
<string> ::= <char> | <char><string>
<char> ::= any of the 128 ASCII characters except <CR> and
<LF>
<marker> ::= <pr-string>
<pr-string> ::= <pr-char> | <pr-char><pr-string>
<pr-char> ::= printable characters, any
              ASCII code 33 through 126
<byte-size> ::= <number>
<host-port> ::= <host-number>,<port-number>
<host-number> ::= <number>,<number>,<number>,<number>
<port-number> ::= <number>,<number>
<number> ::= any decimal integer 1 through 255
<form-code> ::= N | T | C
<type-code> ::= A [<sp> <form-code>]
              | E [<sp> <form-code>]
              | I
              | L <sp> <byte-size>
<structure-code> ::= F | R | P
<mode-code> ::= S | B | C
<pathname> ::= <string>
<decimal-integer> ::= any decimal integer

{% endcodeblock %}

                             



### 各种命令的各种返回码



{% codeblock python lang:python %}

Connection Establishment
   120
      220
   220
   421
Login
   USER
      230
      530
      500, 501, 421
      331, 332
   PASS
      230
      202
      530
      500, 501, 503, 421
      332
   ACCT
      230
      202
      530
      500, 501, 503, 421
   CWD
      250
      500, 501, 502, 421, 530, 550
   CDUP
      200
      500, 501, 502, 421, 530, 550
   SMNT
      202, 250
      500, 501, 502, 421, 530, 550
Logout
   REIN
      120
         220
      220
      421
      500, 502
   QUIT
      221
      500

Transfer parameters
   PORT
      200
      500, 501, 421, 530
   PASV
      227
      500, 501, 502, 421, 530
   MODE
      200
      500, 501, 504, 421, 530
   TYPE
      200
      500, 501, 504, 421, 530
   STRU
      200
      500, 501, 504, 421, 530
File action commands
   ALLO
      200
      202
      500, 501, 504, 421, 530
   REST
      500, 501, 502, 421, 530
      350
   STOR
      125, 150
         (110)
         226, 250
         425, 426, 451, 551, 552
      532, 450, 452, 553
      500, 501, 421, 530
   STOU
      125, 150
         (110)
         226, 250
         425, 426, 451, 551, 552
      532, 450, 452, 553
      500, 501, 421, 530
   RETR
      125, 150
         (110)
         226, 250
         425, 426, 451
      450, 550
      500, 501, 421, 530
   LIST
      125, 150
         226, 250
         425, 426, 451
      450
      500, 501, 502, 421, 530
   NLST
      125, 150
         226, 250
         425, 426, 451
      450
      500, 501, 502, 421, 530
   APPE
      125, 150
         (110)
         226, 250
         425, 426, 451, 551, 552
      532, 450, 550, 452, 553
      500, 501, 502, 421, 530
   RNFR
      450, 550
      500, 501, 502, 421, 530
      350
   RNTO
      250
      532, 553
      500, 501, 502, 503, 421, 530
   DELE
      250
      450, 550
      500, 501, 502, 421, 530
   RMD
      250
      500, 501, 502, 421, 530, 550
   MKD
      257
      500, 501, 502, 421, 530, 550
   PWD
      257
      500, 501, 502, 421, 550
   ABOR
      225, 226
      500, 501, 502, 421

Informational commands
   SYST
      215
      500, 501, 502, 421
   STAT
      211, 212, 213
      450
      500, 501, 502, 421, 530
   HELP
      211, 214
      500, 501, 502, 421
Miscellaneous commands
   SITE
      200
      202
      500, 501, 530
   NOOP
      200
      500 421


{% endcodeblock %}



### 参考文章：


[http://www.w3.org/Protocols/rfc959/](http://www.w3.org/Protocols/rfc959)

[http://vod.sjtu.edu.cn/help/Article_Show.asp?ArticleID=137](http://vod.sjtu.edu.cn/help/Article_Show.asp?ArticleID=137)

[http://blog.miniasp.com/post/2008/06/29/FTP-Protocol-Definitive-Explanation.aspx](http://blog.miniasp.com/post/2008/06/29/FTP-Protocol-Definitive-Explanation.aspx)

Images come from

Computer Networking: A Top Down Approach, 4th edition.

Jim Kurose, Keith Ross Addison-Wesley, July 2007.
