---
comments: true
date: 2012-06-09 19:57:02
layout: post
slug: ubuntu-mysql-backup
title: Ubuntu下自动异地备份数据库
wordpress_id: 1134
categories:
- Linux
tags:
- Linux
- Mysql
- Ubuntu
---

想必大家自己用[VPS](http://everet.org/2012/06/ubuntu-mysql-backup.html)的时候，可能对人工备份都不那么勤快。但是备份确实十分的重要，当服务器硬盘彻底废了、数据库被骇客篡改，此时备份就显得格外的重要。

特别是对于还承载着别人的VPS，我们更需要做好备份。像[屠文翔同学](http://www.kidsang.com/)将自己辛苦翻译《Game Engine Architecture》贴在wordpress博客上，万一哪天服务器的数据库废了，文章找不到了，我该如何面对屠文翔同学啊，所以备份就必不可少了。

我们或许只要一次编程的努力就可以让日后的备份一劳永逸。

嗯，我们可以用脚本将整个数据库dump下来变成文件，放在服务器上作为备份，这样的本地备份万一服务器的数据遭遇了不可恢复的灾难那就悲剧了。所以我们可以寻求异地备份，将备份放置到其他机器上面。


## 异地备份




### 方法一<!-- more -->


我们有空的时候，打开自己的电脑，然后从服务器上面将备份下载回自己的电脑保存。

评论：这样的方法未免有点2B，而且效率实在太低。备份的版本还需要自己保存。真是麻烦。


### 方法二


让服务器将数据库备份到其他服务器上面。

评论：这方法不错，怎么可以比较廉价地实施呢？

我们可以用邮件将我们的数据库备份发送到自己的邮箱。

像Gmail有10GB的空间，QQ邮箱更是无限容量，不够了可以免费扩容。于是乎，邮箱是个非常好的异地备份存放点。而且邮件本来就是一封一封的，我们可以方便地将不同时期的版本下回来比较。此外，我们还可以在邮箱设置收件规则，自动将我们的备份邮件标记为已读并放置到分类到备份文件夹中，这样就不会扰乱我们的正常邮件了。


## 实施


我们可以使用Python来把数据库dump下来，然后压缩，发送到自己的邮箱。然后周期性运行我们可以借助cron按照时间表来运行我们的备份任务。


### cron


首先我们看看如果配置cron运行我们的周期性备份。

cron的配置文件是**/etc/crontab**

每个非注释行代表一个命令：


> _minute hour day month weekday username command_


我们可以加入如下行，


> 30 4 * * 1,3,4 root /etc/apache2/db/backup.py


意思是每周一三四凌晨4点30分运行我们的备份程序。

修改完配置后我们重启一下cron。


> service cron restart




### Python


下面的Python代码是备份整个数据库，然后将备份以附件形式发送到指定邮箱。

我们在用mysqldump将数据库dump下来后再用gzip压缩一下，对于我们的数据库原来是35MB，用gzip压缩后就只有5MB，小了很多。

{% codeblock python lang:python %}
#!/usr/bin/env python
# website: http://EverET.org
import smtplib, os
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email.Utils import COMMASPACE, formatdate
from email import Encoders
import subprocess, time

def send_mail(send_from, send_to, subject, text,
        files=[], server="localhost"):
    assert type(send_to)==list
    assert type(files)==list

    msg = MIMEMultipart()
    msg['From'] = send_from
    msg['To'] = COMMASPACE.join(send_to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    msg.attach( MIMEText(text) )

    for f in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(f,"rb").read() )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition',
                'attachment; filename="%s"'
                % os.path.basename(f))
        msg.attach(part)

    smtp = smtplib.SMTP(server)
    smtp.sendmail(send_from, send_to, msg.as_string())
    smtp.close()

def backup():
    passwd="your password"
    user='root'
    ret = subprocess.call(
            '''mysqldump -u %s -p"%s" --all-databases |
            gzip > /etc/apache2/db/all.sql.gz'''
            % (user, passwd), shell=True)
    return ret

if __name__ == '__main__':
    if backup() == 0:
        send_mail(
            'et@everet.org',        # from mail
            ['your@mail.com'],   # to mail
            'all database backup',
            'backup time:%s'
            % (time.strftime(time.asctime()), ),
            ['/etc/apache2/db/all.sql.gz'])
    else:
        print 'error'
{% endcodeblock %}

因为我们数据库的密码是写在了脚本里面，所以我们需要修改权限，让仅自己可读，以提高安全性。

{% codeblock bash lang:bash %}
chmod 700 backup.py
{% endcodeblock %}

