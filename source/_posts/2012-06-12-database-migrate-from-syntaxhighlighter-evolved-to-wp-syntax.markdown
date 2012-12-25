---
comments: true
date: 2012-06-12 16:33:42
layout: post
slug: database-migrate-from-syntaxhighlighter-evolved-to-wp-syntax
title: 从syntaxhighlighter evolved迁移至wp-syntax
wordpress_id: 1201
categories:
- IT
tags:
- Python
- Wordpress
---

Syntaxhighlighter Evolved是一款Javascript的语法高亮插件，高亮是在用户的浏览器完成，这样可以减轻服务器的压力。而WP-Syntax恰恰相反，它是在服务器完成语法高亮。WP-Syntax比Syntaxhighlighter Evolved更有优势的地方是支持rss高亮，而且支持的语言众多，使用了GeSHi高亮引擎，可定制性相当强，至于高亮带来的压力，我们可以用缓存插件来解决。


#### Syntaxhighlighter Evolved Plugin Usage


Just wrap your code in `[language]`, such as `[php]code here[/php]**` or `[css]code here[/css]`.


#### WP-Syntax Basic Usage


Wrap code blocks with `<pre lang="LANGUAGE" line="1">` and `</pre>`

我们很明显就可以看到两者之间的区别。Syntaxhighlighter Evolved用的是非常特殊的高亮标记**[language]**，如果我们直接卸载Syntaxhighlighter Evolved然后装上WP-Syntax就会导致Syntaxhighlighter Evolved的高亮标记直接输出，而且代码不会被高亮。

我们必须将Syntaxhighlighter Evolved的高亮标记全部替换成WP-Syntax的高亮标记。

对于这种这么繁琐的事情，我们就把它交给Python来完成吧。<!-- more -->


###  代码



{% codeblock python lang:python %}

#!/usr/bin/env python
# author:  Hua Liang [ Stupid ET ]
# email:   et@everet.org
# website: http://EverET.org
#
# database migrate from syntaxhighlighter evolved to wp-syntax

import re, sys

def sub(pat, text, new_str):
    py = re.compile(pat, re.IGNORECASE)
    sql = py.sub(new_str, text)
    return sql 

sql = sys.stdin.read()
#sql = open('et.sql').read()

# [python] => <pre lang="python">
sql = sub(r'\[python.*?\]', sql, '<pre lang="python" escaped="true">')
sql = sub(r'\[/python\]', sql, '</pre>')

sql = sub(r'\[plain.*?\]', sql, '<pre lang="text" escaped="true">')
sql = sub(r'\[/plain\]', sql, '</pre>')

sql = sub(r'\[code.*?\]', sql, '<pre lang="text" escaped="true">')
sql = sub(r'\[/code\]', sql, '</pre>')

sql = sub(r'(\[c(\s.*?)?\])', sql, '<pre lang="cpp" escaped="true">')
sql = sub(r'\[/c\]', sql, '</pre>')

sql = sub(r'\[shell.*?\]', sql, '<pre lang="bash" escaped="true">')
sql = sub(r'\[/shell\]', sql, '</pre>')

sql = sub(r'\[php.*?\]', sql, '<pre lang="php" escaped="true">')
sql = sub(r'\[/php\]', sql, '</pre>')

sql = sub(r'\[lisp.*?\]', sql, '<pre lang="lisp" escaped="true">')
sql = sub(r'\[/lisp\]', sql, '</pre>')

sql = sub(r'\[javascript.*?\]', sql, '<pre lang="javascript" escaped="true">')
sql = sub(r'\[/javascript\]', sql, '</pre>')

sql = sub(r'\[html.*?\]', sql, '<pre lang="html" escaped="true">')
sql = sub(r'\[/html\]', sql, '</pre>')

sql = sub(r'\[c\+\+.*?\]', sql, '<pre lang="cpp" escaped="true">')
sql = sub(r'\[/c\+\+\]', sql, '</pre>')

sql = sub(r'\[c#.*?\]', sql, '<pre lang="csharp" escaped="true">')
sql = sub(r'\[/c#\]', sql, '</pre>')

# for s in re.findall(r'\<pre lang=\".*?\"\>', sql):
#     print s
# for s in re.findall(r'\[/.*?\]', sql):
#     print s

#output = open('fix-et.sql', 'w')
output = sys.stdout
output.write(sql)
output.close()
{% endcodeblock %}

最新源码：[https://github.com/cedricporter/et-python/blob/master/migrate-db/migrant.py](https://github.com/cedricporter/et-python/blob/master/migrate-db/migrant.py)




### 使用

{% codeblock bash lang:bash %}
mysqldump -u root -p wordpress_db | ./migrant.py > fix.sql
mysql -u root -p wordpress_db < fix.sql
{% endcodeblock %}


整个过程就是
  1. 使用mysqldump将数据库dump成文本
  2. 通过我们的过滤器程序migrant.py将syntaxhighlighter evolved的高亮风格变成wp-syntax的高亮风格。
  3. 导入回数据库。

搞定!

对于WP-Syntax的Python多行字符串高亮的bug解决请见：

[http://everet.org/2012/06/fix-wp-syntax-python-string-bug.html](http://everet.org/2012/06/fix-wp-syntax-python-string-bug.html)
