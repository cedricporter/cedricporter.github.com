---
layout: post
title: "深圳证券交易所行情对接"
date: 2017-07-20 16:46
comments: true
categories: quant
tags: quant
---

最近在对接证券交易所的 Level-1 行情，搜索了一下，感觉民间的资料不是很多，而且交易所的哥们日理万机，回复也不是很及时，所以还是记录一下，避免其他人反复浪费时间。咨询了LDDS的运维，他的建议是上交所和深交所行情「**分开接收**」。

上海证券交易所提供的 LDDS-VDE [^1] 是一个纯 Java 的服务，启动后，VDE[^2] 会和 DDS[^6] 服务器建立 TCP 连接，并且按需短连接 DRS[^7] 服务器。我们可以从它获取到上海证券交易所和深圳证券交易所的行情数据。按照文档启动 VDE 还是非常方便的。

{% img /imgs/2017-07-23-16-36-38.png %}

对于上交所的行情，默认配置的 `com.sseinfo.lddsidc.thread.vss.RealTimeClientThread` 会将行情快照，约每隔3秒更新到文件中 `mktdt00.txt`（还有其他文件包含其他信息），我们可以通过读取文件，或者直接连接 VDE 的 9129 端口获取到上交所的行情。

### 深交所

对于深交所，LDDS-VDE 只是对深交所的行情数据进行了转发，虽然在 9129 也可以读取到深交所的数据，但是建议还是连接 VDE 的 `6666` 端口通过 Binary 协议获取深交所的行情数据。

<!-- more -->

问了一圈，并没有连接 VDE 的 demo client 可以参考学习。不过好在 Python 开发速度快，用 struct 库就可以直接解析字节流。花了一天时间终于把协议调通了。

需要注意的一点是，深交所的 Binary 协议的整数是高字节序（Big-Endian），其他的都还好。

{% img /imgs/2017-07-23-17-16-24.png %}

建立了 TCP 连接后，VSS[^3]需要向 VDE 发送 Logon 请求，此时如果登录没有问题，VDE 会回复 Logon 请求。随后就会开始推送行情数据过来了。

与此同时，我们需要在空闲的时候定时发送 Heartbeat 消息以供检查连接有没有断掉。Heartbeat 间隔为我们在 Logon 请求中设置的 HeartBtInt 。

### Binary协议

所有的消息，都是有3部分组成，消息头，消息体和消息尾。消息头有8个字节，是两个整数 MsgType 和 BodyLen。MsgType 标识者这个消息的类型，BodyLen 则表示接下来的消息体有多少个字节，我们根据 BodyLen 将消息体读出来。剩下就是4个字节的 checksum 了，

{% img /imgs/QQ20170723-141315.png %}

checksum 的计算非常简单，如下：

{% img /imgs/2017-07-23-17-22-55.png %}

如果我们需要给 VDE 发送消息，也是这种消息格式。

剩下的就是按照协议解析各种行情消息了，主要是 MsgType=300111 的集中竞价行情和 MsgType=309011 的指数行情快照等，就没啥难度了。


[^1]: LDDS: 低延时行情发布系统（Low–Latency Data Distribution System）。

[^2]: VDE: Vendor Data Engine 前置机，深圳证券交易所新行情系统提供给信息商系统的接入点服务器。

[^3]: VSS: Vendor Supplied System 信息商服务器，经过许可接入深圳证券交易所新行情系统的信息商服务器。

[^4]: STEP: 证券交易数据交换协议 STEP Protocol (FIX based Exchange protocol)。

[^5]: FAST: FIX Adapted for Streaming。

[^6]: DDS: IDC 中的数据发布服务器

[^7]: DRS: IDC 中的数据重建服务器

[^8]: IDC: 本文特指 Level-2 行情发布中心（Information Data Centre of SSE）
