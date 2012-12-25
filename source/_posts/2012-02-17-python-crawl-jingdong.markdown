---
comments: true
date: 2012-02-17 18:53:24
layout: post
slug: python-crawl-jingdong
title: Python抓取京东商城的所有笔记本电脑的参数
wordpress_id: 532
categories:
- My Code
tags:
- Python
- Web
---

最近洪爷要写数据挖掘的论文需要些数据，于是俺又有机会做苦力了。昨天刚刚回到学校，晚上就帮洪爷写了个爬虫来爬数据京东商城的笔记本的参数。

为了快速完成，基本原理就是人工找到笔记本的页面。

然后他有22页（Page），编号规则如下：

http://www.360buy.com/products/670-671-672-0-0-0-0-0-0-0-1-1-1.html

http://www.360buy.com/products/670-671-672-0-0-0-0-0-0-0-1-1-%d.html

http://www.360buy.com/products/670-671-672-0-0-0-0-0-0-0-1-1-22.html

<!-- more -->

我们可以先访问每一页，每一页有很多个笔记本，然后我们从中汲取出每个笔记本的页面的url，记录下每台笔记本的网页的url，然后在访问每一个笔记本的页面，从中取出笔记本的参数，OK，非常简单，打完收工。

为了加速，我们采用多线程，一些工作线程访问Page，从中取出笔记本产品Product的url放到一个队列里。然后另一些工作线程从队列里取出笔记本的url，然后从中取出笔记本的参数。然后输出到文件中。

[![QQ截图20120217184108](http://everet.org/wp-content/uploads/2012/02/QQ20120217184108_thumb.png)](http://everet.org/wp-content/uploads/2012/02/QQ20120217184108.png)

{% codeblock %}
点击下载源代码：[jindong](http://everet.org/wp-content/uploads/2012/02/jindong.rar)

{% codeblock python lang:python %}

#!/usr/bin/env python
# author: Cedric Porter [ Stupid ET ]
# contact me: cedricporter@gmail.com

from urllib import urlopen
import threading
import re
import Queue

def get_info(url):
    '''abstracts product info '''
    p = re.compile('<tr><td .*?>(.*?)</td><td>(.*?)</td></tr>')
    text = urlopen(url).read()
    info = []

    for t, v in p.findall(text):
        info.append((t, v))

    return info

def get_urls(page_url):
    '''gets product urls from a page'''
    p = re.compile(r"<div class='p-name'><a target='_blank' href='(.*?)'>", re.S)
    text = urlopen(page_url).read()

    urls = []
    for url in p.findall(text):
        urls.append(url)

    return urls

def get_page_urls():
    '''creates urls of the pages'''
    page_urls = []
    for i in range(1, 23):
        page_urls.append('http://www.360buy.com/products/670-671-672-0-0-0-0-0-0-0-1-1-%d.html'% i)
    return page_urls

def product_worker(product_url_queue):
    '''thread of product worker, downloads product info'''
    global g_mutex, f, g_c, g_done
    while not g_done or product_url_queue.qsize() > 0:
        url = product_url_queue.get()
        try:
            info = get_info(url)
        except Exception, e:
            product_url_queue.put(url)
            print e
            continue

        g_mutex.acquire()
        print '==>', g_c
        g_c += 1
        for t, v in info:
            f.write(t + ':::' + v + '\n')
        f.write('\n#####\n')
        f.flush()
        g_mutex.release()

def page_urls_worker(product_url_queue, page_url):
    '''thread function of page urls worker, downloads page urls'''
    for product_url in get_urls(page_url):
        product_url_queue.put(product_url)
        print '.'

f = open('data.txt', 'w')   # output file
g_c = 0                     # counter, for telling us the process
g_done = False              # end flag
g_mutex = threading.Lock()  # mutex

def main():
    global g_done
    threading_pool = []
    q = Queue.Queue()
    num_product_worker = 50

    for i in range(num_product_worker):
        th = threading.Thread(target=product_worker, args=(q,))
        threading_pool.append(th)
        th.start()

    page_urls_worker_pool = []
    for page_url in get_page_urls():
        pth = threading.Thread(target=page_urls_worker, args=(q, page_url))
        pth.start()
        page_urls_worker_pool.append(pth)

    for th in page_urls_worker_pool:
        threading.Thread.join(th)

    g_done = True

    for th in threading_pool:
        threading.Thread.join(th)

if __name__=='__main__':
    main()


{% endcodeblock %}

输出如下的文件：
[![](http://everet.org/wp-content/uploads/2012/02/QQ截图20120217192017.png)](http://everet.org/wp-content/uploads/2012/02/QQ截图20120217192017.png)
{% endcodeblock %}

