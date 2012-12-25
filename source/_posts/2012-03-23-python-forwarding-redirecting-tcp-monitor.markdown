---
comments: true
date: 2012-03-23 14:41:54
layout: post
slug: python-forwarding-redirecting-tcp-monitor
title: Python端口转发及重定向实现Eclipse的TCP/IP Monitor
wordpress_id: 819
categories:
- My Code
- Web
tags:
- Python
- Web
---

记得在上个学期的时候选了徐扬老师的《Web服务与面向服务的体系结构》，讲了SOA之类的一堆东西。然后实验就是要4个下午做完IBM一个星期的培训课程……

于是偶们便开始无脑地照着下面这本手册来狂做实验。记得要做10多个实验，算一下一个下午要做2-3个实验，所以当场做的话只能无脑操作鸟。不能不说是教育的悲哀啊。

[![QQ截图20120323140703](http://everet.org/wp-content/uploads/2012/03/QQ20120323140703_thumb.png)](http://everet.org/wp-content/uploads/2012/03/QQ20120323140703.png)

记得在做“**Exercise 7. Creating Web service clients**”，有一小节是使用TCP/IP Monitor来检查SOAP消息。

也就是在Eclipse的TCP/IP Monitor中，设置监听一个端口如9081，然后设置你的SOA服务器的端口9080。然后你和9081端口的通信就会重定向到了9080.然后你就可以看到他们的数据传输。

<!-- more -->



[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb4.png)](http://everet.org/wp-content/uploads/2012/03/image4.png)

当我们发送SOAP消息时候，就可以在TCP/IP Monitor中看到我们的SOAP消息了。

[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb5.png)](http://everet.org/wp-content/uploads/2012/03/image5.png)


## 




## Python出场


其实上述功能，其原理就是端口的转发和重定向，再加上把中间的信息输出罢了。

首先，我们用webpy写一个简单的网站，监听8080端口，返回“Hello, EverET.org”的页面。

然后我们使用我们的forwarding.py，在80端口和8080端口中间建立两条通信管道用于双向通信。

此时，我们通过80端口访问我们的服务器。

浏览器得到：

[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb6.png)](http://everet.org/wp-content/uploads/2012/03/image6.png)

然后，我们在forwarding.py的输出结果中可以看到浏览器和webpy之间的通信内容。

[![image](http://everet.org/wp-content/uploads/2012/03/image_thumb7.png)](http://everet.org/wp-content/uploads/2012/03/image7.png)


### 代码：



{% codeblock python lang:python %}

#!/usr/bin/env python
import sys, socket, time, threading

loglock = threading.Lock()
def log(msg):
    loglock.acquire()
    try:
        print '[%s]: \n%s\n' % (time.ctime(), msg.strip())
        sys.stdout.flush()
    finally:
        loglock.release()

class PipeThread(threading.Thread):
    def __init__(self, source, target):
        threading.Thread.__init__(self)
        self.source = source
        self.target = target

    def run(self):
        while True:
            try:
                data = self.source.recv(1024)
                log(data)
                if not data: break
                self.target.send(data)
            except:
                break
        log('PipeThread done')

class Forwarding(threading.Thread):
    def __init__(self, port, targethost, targetport):
        threading.Thread.__init__(self)
        self.targethost = targethost
        self.targetport = targetport
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind(('0.0.0.0', port))
        self.sock.listen(10)
    def run(self):
        while True:
            client_fd, client_addr = self.sock.accept()
            target_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            target_fd.connect((self.targethost, self.targetport))
            log('new connect')
            # two direct pipe
            PipeThread(target_fd, client_fd).start()
            PipeThread(client_fd, target_fd).start()
            

if __name__ == '__main__':
    print 'Starting'
    import sys
    try:
        port = int(sys.argv[1])
        targethost = sys.argv[2]
        try: targetport = int(sys.argv[3])
        except IndexError: targetport = port
    except (ValueError, IndexError):
        print 'Usage: %s port targethost [targetport]' % sys.argv[0]
        sys.exit(1)

    #sys.stdout = open('forwaring.log', 'w')
    Forwarding(port, targethost, targetport).start()         

{% endcodeblock %}



更多我的Python代码请见：[https://github.com/cedricporter/et-python](https://github.com/cedricporter/et-python)
