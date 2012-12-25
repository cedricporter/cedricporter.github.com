---
comments: true
date: 2012-03-16 19:19:52
layout: post
slug: python-parse-ogre-configuration-file
title: 神奇的Python：解析OGRE配置文件
wordpress_id: 705
categories:
- My Code
tags:
- OGRE
- Python
---

> OGRE（Object-Oriented Graphics Rendering Engine，即：面向对象图形渲染引擎）是一个用C++开发的面向场景、非常灵活的3D引擎，它旨在让开发人员更容易、更直接地利用硬件加速的3D图形系统开发应用。这个类库隐藏了底层系统库（如：Direct3D和OpenGL）的所有细节，提供了一个基于世界对象和其他直观类的接口。 译者注:ogre在英文中意为：食人魔鬼, 怪物, 象鬼的人，故其LOGO是一个怪物头。


以上引用自百度百科。

OGRE的很多东西都通过配置文件来控制，这样会很灵活。

配置文件的例子如下：


> [Bootstrap]
Zip=../media/packs/OgreCore.zip

# Resource locations to be added to the default path
[General]
FileSystem=../media
FileSystem=../media/fonts
FileSystem=../media/sounds
Zip=../media/packs/ogretestmap.zip
Zip=../media/packs/skybox.zip
#Zip=../media/packs/chiropteraDM.pk3


它分了section，在section下有许多配置语句，也就是一些赋值语句。

其配置文件的文法类似如下：<!-- more -->


> file –> section+

section –> ‘[‘ identifier ‘]’body

body –> statement

statement –> assign_statement

assign_statement –> identifer ‘=’value


我们可以借助一个Python的SimpleParse模块进行分析。这是一款强大Python解析模块。

可以围观上文[ http://everet.org/2012/03/the-format-grammer.html](http://everet.org/2012/03/the-format-grammer.html)

以下是一个解析OGRE配置文件的Python代码。


{% codeblock python lang:python %}

declaration = r'''
file           :=  [ \t\n]*, section+
section        :=  '[', section_name, ']', ts,'\n', body
section_name   :=  identifier
body           :=  statement*
statement      :=  (ts,'#', -'\n'*,'\n')/equality/nullline
nullline       :=  ts,'\n'
equality       :=  ts, item, ts, '=', ts, value, ts, '\n'
item           := identifier
identifier     :=  [a-zA-Z], [a-zA-Z0-9_]*
value          :=  -'\n'*
ts             :=  [ \t]*
'''

text = '''
[Bootstrap]
Zip=../media/packs/OgreCore.zip

# Resource locations to be added to the default path
[General]
FileSystem=../media
FileSystem=../media/Audio
FileSystem=../media/sounds
FileSystem=../media/materials/programs
FileSystem=../media/materials/scripts
FileSystem=../media/materials/textures
FileSystem=../media/models
FileSystem=../media/overlays
Zip=../media/packs/ogretestmap.zip
#Zip=../media/packs/chiropteraDM.pk3

'''
from simpleparse.parser import Parser
import pprint

lastItem = None
section_name = ''
def config_maker(tag, start, end):
    '''make the config tuple, and adds them to config'''
    global config, text, lastItem, section_name
    if tag == 'section_name':
        section_name = text[start:end]
    elif tag == 'item':
        lastItem = text[start:end]
    elif tag == 'value':
        config.append((lastItem, text[start:end]))

def travel(root, func):
    if root == None: return

    tag, start, end, children = root
    func(tag, start, end)

    if children != None:
        for item in children: travel(item, func)

if __name__ =="__main__":
    parser = Parser( declaration, "file" )
    success, resultTrees, nextChar = parser.parse(text)

    output = {}
    for section in resultTrees:
        config = []
        travel(section, config_maker)
        output[section_name] = config

    pprint.pprint(output)

{% endcodeblock %}



输出如下的内容，我们就可以很方便地读取里面的内容了。
[![](http://everet.org/wp-content/uploads/2012/03/QQ截图20120316192157.png)](http://everet.org/wp-content/uploads/2012/03/QQ截图20120316192157.png)
