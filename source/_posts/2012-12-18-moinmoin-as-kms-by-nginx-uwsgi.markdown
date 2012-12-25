---
comments: true
date: 2012-12-18 23:14:27
layout: post
slug: moinmoin-as-kms-by-nginx-uwsgi
title: MoinMoin+Nginx+uWSGI搭建个人Wiki
wordpress_id: 1482
categories:
- IT
tags:
- MoinMoin
- Nginx
- Python
- uWSGI
---

## 有博客，为什么还需要Wiki呢？


有博客，为什么还需要Wiki呢？对于这个问题，我也思考了许久。博客记录的东西很扁平，而且不太适宜记录一些零碎不完整的东西。如果别人订阅了你的博客，你的博客却经常发布一些不完整的内容，这样会严重影响别人的心情。所以我觉得博客适宜将一些比较完整的内容的写在里面。此外，平时在网上看到什么东西，虽然都可以收录到EverNote里面（EverNote里面有提供目录以及标签可以很好地进行分类），但是，EverNote的劣势在于，不方便将知识组织知识，将它们串联在一起。

而在Wiki中知识是以词条形式，词条与词条间可以方便地建立关系。很容易组织成树状结构。

此外，Wiki可以使用轻量标记语言编写，优点是纯文本，容易阅读和编辑，能够让我们的注意力集中于撰写内容而非形式。特别在Emacs或者Vim里面可以方便地半可视化地编写Wiki。我第一次尝试就对其爱不释手，终于可以从Wordpress，Word等SB的需要鼠标辅助编辑的编写过程中解脱了。

于是我又开始物色Wiki，以前有用过PHP实现的Wiki，现在决定找一个Python实现的Wiki，很快就找到了[MoinMoin](http://i.everet.org/MoinMoin)，它是一个由Python实现的[Wiki](http://zh.wikipedia.org/wiki/Wiki)系统，文件存储，选一种自己喜欢的语言编写的Wiki系统，日后定制起来会方便一些。<!-- more -->

我的Wiki：[http://i.everet.org](http://i.everet.org/)

这个Wiki是我前段时间在这个性能忒差的服务器上面搭建的，今天终于把配置过程写下来，希望能给有需要的同学多一份参考。

前端依旧是Nginx，后端用uWSGI处理Python。Nginx可以很好的转发。




## Nginx的配置




### Install




> 

{% codeblock %}
# apt-get install python-software-properties
# apt-add-repository ppa:nginx/stable
# apt-get update
# apt-get install nginx-full
{% endcodeblock %}




我们在/etc/nginx/sites-available文件夹里面新建一个文件wiki.everet.org，然后链接到sites-enables。就可以运行nginx -t && service nginx reload:

{% codeblock nginx lang:nginx %}
server {
    server_name i.everet.org wiki.everet.org;

    access_log  /var/log/nginx/wiki.everet.org.access.log;
    error_log /var/log/nginx/wiki.everet.org.error.org;

    location / {
        include uwsgi_params;
        uwsgi_pass unix:///var/run/uwsgi_wiki.sock;
        uwsgi_param UWSGI_PYHOME /var/www/moinmoin/python-env/;
        uwsgi_param UWSGI_CHDIR /var/www/moinmoin/wiki/;
        uwsgi_param UWSGI_SCRIPT moin_wsgi;
    }

    location = /google7a32e07f62c143af.html {
        rewrite ^/ /moin_static195/google7a32e07f62c143af.html;
    }

    location ^~ /moin_static195/ {
        alias /var/www/moinmoin/python-env/lib/python2.7/site-packages/MoinMoin/web/static/htdocs/;
        add_header Cache-Control public;
        expires 1M;
    }
}
{% endcodeblock %}




## Python


在这里，我们需要借助一个程序virtualenv，它可以创建一个干净的Python运行环境。其实Python核心就是一个解释器，然后外加许多包，也就是所谓的“电池”。如果我们自己编译Python的话，可以选择生成一个静态链接的Python可执行文件，就可以拿着这个解释器文件走了。

而virtualenv做的事情就是将Python解释器以及一些需要的包复制到我们指定的地方，已经创建一些方便设置环境变量的脚本。当我们有程序需要不同版本的模块或者某些不兼容的模块时，就可以借助于virtualenv。

Virtualenv会生成一个包含Python可执行程序的目录，里面也会包含标准库。

此外，我们需要运行bin目录下面的activate，它会修改当前的环境变量。

activate这个脚本做的事情就是将新的Python可执行的路径加入到环境变量PATH最前面。然后清空PYTHONHOME这个环境变量。


> 

{% codeblock %}
# mkdir -p /var/www/moinmoin
# virtualenv /var/www/moinmoin/python-env
# . /var/www/moinmoin/python-env/bin/activate
{% endcodeblock %}




运行完activate后，环境变量就改了，我们可以看到提示符已经改变了。然后我们进行后续工作。




## MoinMoin


然后现在安装moinmoin


> 

{% codeblock %}
(python-env) # python setup.py install
{% endcodeblock %}




然后将安装目录的wiki文件夹下面的data与uderlay目录复制出来，放到/var/www/moinmoin/wiki。然后将wiki/config目录下的wikiconfig.py以及wiki/server/moin.wsgi改名moin_wsgi.py复制到/var/www/moinmoin/wiki目录下面，然后/var/www/moinmoin/wiki目录结构如下：


> 

{% codeblock %}
root@ubuntu:/var/www/moinmoin/wiki# tree -L 1
.
├── data
├── moin_wsgi.py
├── underlay
└── wikiconfig.py

2 directories, 2 files
{% endcodeblock %}




然后将wiki目录修改属主为uwsgi。


> 

{% codeblock %}
# chown uwsgi:uwsgi /var/www/moinmoin/wiki -R
{% endcodeblock %}







## uWSGI




### Install


安装最新的lts版的uwsgi，不过在此之前，需要安装python-dev才能够正确编译。


> 

{% codeblock %}
# sudo apt-get install python-dev build-essential
(python-env) # pip install http://projects.unbit.it/downloads/uwsgi-lts.tar.gz
{% endcodeblock %}




如果我们还在virtualenv的环境变量下，uwsgi会被安装到/var/www/moinmoin/python-env/bin下面，就一个文件uwsgi。


### Autostart


我们现在来为uwsgi编写开机启动：

{% codeblock bash lang:bash %}
# /etc/init.d/uwsgi
#

daemon=/var/www/moinmoin/python-env/bin/uwsgi
pid=/var/run/uwsgi.pid
args="-x /etc/uwsgi/uwsgi.xml"

case "$1" in
    start)
        echo "Starting uwsgi"
        start-stop-daemon -p $pid --start --exec $daemon -- $args
        ;;
    stop)
        echo "Stopping script uwsgi"
        start-stop-daemon --signal INT -p $pid --stop $daemon -- $args
        ;;
    restart)
        echo "Restarting uwsgi"
        start-stop-daemon --signal INT -p $pid --stop $daemon -- $args
        sleep 2
        start-stop-daemon -p $pid --start --exec $daemon -- $args
        ;;
    reload)
        echo "Reloading conf"
        kill -HUP $(cat $pid)
        ;;
    *)
        echo "Usage: /etc/init.d/uwsgi {start|stop|restart|reload}"
        exit 1
        ;;
esac

exit 0
{% endcodeblock %}



### Config


/etc/uwsgi/uwsgi.xml内容如下：

{% codeblock xml lang:xml %}


    /var/run/uwsgi_wiki.sock
    uwsgi
    uwsgi
    
    128
    /var/www/moinmoin/wiki/wikiconfig.py
    
    3
    
    
    
    /var/run/uwsgi.pid
    /var/log/uwsgi.log


{% endcodeblock %}




	
  * 其中reload-on-as是指内存消耗达到128就重新加载过进程。

	
  * touch-reload是指wikiconfig.py被修改就重新加载进程。

	
  * master-as-root是指master进程uid为root，这样才有足够权限在/var/run中创建socket。


其他参数就没什么特别的了。


### Add User


添加用户


> 

{% codeblock %}
# adduser --system --no-create-home --disabled-login --disabled-password --group uwsgi
# touch /var/log/uwsgi.log
# chown uwsgi:uwsgi /var/log/uwsgi.log
{% endcodeblock %}






### Run


加到开机启动，然后运行uwsgi服务。


> 

{% codeblock %}
# update-rc.d uwsgi defaults
# service uwsgi start
{% endcodeblock %}






## 扩展阅读





	
  * [UWSGI_SCRIPT](http://uwsgi-docs.readthedocs.org/en/latest/Nginx.html#dynamic-apps)

	
  * [uwsgi protocol magic variables](https://uwsgi-docs.readthedocs.org/en/latest/Vars.html?highlight=%20UWSGI_CHDIR)

        
  * [Emacs的moinmoin-mode](http://moinmo.in/EmacsForMoinMoin)


