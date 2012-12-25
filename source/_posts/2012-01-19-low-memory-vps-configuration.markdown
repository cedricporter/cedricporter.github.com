---
comments: true
date: 2012-01-19 21:36:01
layout: post
slug: low-memory-vps-configuration
title: 低内存VPS的配置
wordpress_id: 90
categories:
- Life
tags:
- Apache
- Linux
- LNMP
- Mysql
- Nginx
- PHP
- ppp
- pptpd
- sendmail
- virtual memory
- VPN
---

十几天前和隔壁宿舍的伟大的晓彬同学一起低价购置了一台二手电脑摆在宿舍做服务器，处理器虽然只有1.6Ghz，不过至少也有1G的内存可用。装了Ubuntu Server 11.10，机箱后面只是插了电源和网线，因为木有钱，所有就不买显示器，不过买了也占位置。另外，因为学校是华南地区教育网的接入点，所以我们每人端口都有一个公网的固定IP，这是做服务器的良好条件啊~这个真是太幸福啦~

不过寒假回家了，宿舍的服务器总不能开着吧，到时把宿舍烧了就悲剧了:-( 。于是乎，还是租个虚拟服务器比较靠谱。

在两天前奖学金终于到了，于是便下手买了VPS，原因有很多，主要就是要有一台常开的机器来服务我们这些人类。其实发现有台在国外的VPS确实挺好的，最主要的就是可以提供VPN。自己从零开始搭建服务器，既是机遇也是挑战啊~

好，现在回忆一下如何搭建这个网站。<!-- more -->


## **必要的话可以修改时区**




cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime





## **内存小，增加虚拟内存**




如何增加虚拟内存呢？这个在《鸟哥的Linux私房菜》里面说了有比较详细的说明，这里也简要提一下。




{% codeblock bash lang:bash %}

$
$ cd /var
$ # 生成一个256MB的文件，262144 = 256 * 1024 = 256K
$ dd if=/dev/zero of=/var/swapfile bs=1024 count=262144
$ # mkswap可将磁盘分区或文件设为Linux的交换区
$ mkswap /var/swapfile
$ # 启动系统交换区(swap area)
$ swapon /var/swapfile
$ # 显示交换区的使用状况
$ swapon -s
$

{% endcodeblock %}



## **搭建VPN**



{% codeblock bash lang:bash %}

#!/bin/bash
apt-get update
apt-get -y install ppp pptpd iptables
# 设置DNS
echo ms-dns 208.67.222.222 >> /etc/ppp/pptpd-options
echo ms-dns 208.67.220.220 >> /etc/ppp/pptpd-options
echo localip 192.168.99.1 >> /etc/pptpd.conf
echo remoteip 192.168.99.9-99 >> /etc/pptpd.conf
# 设置防火墙
# 如果出现restorecon command not found，可以apt-get install policycoreutils
iptables -t nat -A POSTROUTING -s 192.168.99.0/24 -j MASQUERADE
# 加到rc.local让开机会重新设置过滤
sed -i 's/exit\ 0/#exit\ 0/' /etc/rc.local
echo iptables -t nat -A POSTROUTING -s 192.168.99.0/24 \
-j MASQUERADE >> /etc/rc.local
echo exit 0 >> /etc/rc.local
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -p
# 添加用户test_user，密码test_password
# 格式
#  client        server     secret                IP addresses
echo test_user \* test_password \* >> /etc/ppp/chap-secrets
# 其中IP地址这一列，我们可以为特定用户手工指定特定IP。
# 如果没有指定，为"*"，那么PPTP VPN服务器从/etc/pptp.conf文件中
# 我们设定的remoteip中选择一个分配给客户端。

# 重启pptpd让设置生效
/etc/init.d/pptpd restart

{% endcodeblock %}



## 搭建邮件服务器




apt-get install sendmail, 然后就可以用sendmail somebody@qq.com发送邮件了，这里还没有讲述如何配置收件，不过发件可以了。收件配置稍后在补全。




apt-get install postfix
apt-get install mailutils





## **配置Web服务器**




虽然我还是挺想用Apache的，不过太占资源了，所以还是用轻量级一点的nginx，日后有空再自己写个更简单轻量的。整体配置为 Linux + Nginx + PHP-fpm + Mysql，也是传说中的 LNMP。这个在Ubuntu 10.10上搭建还是灰常简单滴。




我们可以使用下列命令完成安装




{% codeblock bash lang:bash %}

apt-get update
apt-get install mysql-server
apt-get install nginx
apt-get install php5-cgi php5-mysql php5-fpm php5-curl php5-gd \
php5-idn php-pear php5-imagick php5-imap php5-mcrypt \
php5-memcache php5-mhash php5-ming php5-pspell \
php5-recode php5-snmp php5-tidy php5-xmlrpc php5-xsl

{% endcodeblock %}


然后就可以用 service --status-all 查看所有的服务。
我们可以用 vi /etc/php5/fpm/php.ini 修改php的配置。可以加上 cgi.fix_pathinfo=0 这句，因为可能会导致可以上传图片扩展名的php，然后可以通过路径访问执行php，如果出现这种情况那就悲剧了。
好，现在我们开始配置nginx，我们可以 vi /etc/nginx/sites-available/default 编辑


{% codeblock text lang:text %}

server {
	listen   80; ## listen for ipv4
		listen   [::]:80 default ipv6only=on; ## listen for ipv6
		server_name  www.everet.org everet.org;
	access_log  /var/log/nginx/et/localhost.access.log;
	location / {
		if (!-f $request_filename){
			rewrite (.*) /index.php;
		}
		root   /var/www/et;
		index  index.php index.html index.htm;
	}
	location ~ \.php$ {
		fastcgi_pass   127.0.0.1:9000;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  /var/www/et$fastcgi_script_name;
		include		 fastcgi_params;
	}
}

{% endcodeblock %}


然后就完成了基本的配置。
