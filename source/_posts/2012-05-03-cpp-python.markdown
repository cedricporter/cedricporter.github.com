---
comments: true
date: 2012-05-03 21:21:46
layout: post
slug: cpp-python
title: C++与Python混合编程
wordpress_id: 972
categories:
- 我的代码
tags:
- C++
- Python
---

混合语言策略可以汲取各语言之所长，让开发更加敏捷。混合语言策略在在应用得当时可以让程序更加优雅。

在《Unix编程艺术》中，Raymond说道：


> 混合语言是一种知识密集型（而不是编码密集型）的编程。要让它能够工作，我们不仅应该具备相当数量的多种语言应用知识，并且还需要具备能够判断这些语言在什么地方最适合、以及怎样把他们组合在一起的潜经验。


在混合语言编程中，我们遇到的第一个问题是如何需要让他们可以互相调用。也就是像C++可以调用Python的函数、Python又可以调用C++的函数。

对于C++和Python的混合编程主要有两种方式。



	
  1. 将C++写的模块编译成动态链接库，然后由Python主程序使用。这种一般是单方向的使用。

	
  2. 用C++主程序调用Python。然后Python中可以使用C++主程序的函数。


对于第一种方式非常简单，我们在此就不讨论了。我们将着重讨论第二种方式。<!-- more -->


## Simple Exampe of Mixing C++ and Python Code


我们举个例子。以下是C++主程序，做的事情是创建了一个空白的地图，然后加载Python模块构建地图。


{% codeblock cpp lang:cpp %}

// website: http://EverET.org
#include <iostream>
#include <vector>
#include <boost/python.hpp>

class Map
{
public:
    Map() : m_map(10, std::vector<char>(20, '.'))
    {}

    void SetPixel(int x, int y, int val)
    {
	m_map[y][x] = val;
    }

    void Print()
    {
	for (int i = 0; i < m_map.size(); ++i)
	{
	    for (int j = 0; j < m_map[i].size(); ++j)
	    {
		std::cout << m_map[i][j];
	    }
	    std::cout << std::endl;
	}
    }

private:
    std::vector<std::vector<char> > m_map;
};

void InitPython()
{
    Py_Initialize();

    if(!Py_IsInitialized())
    {
	exit(-1);
    }
}

// Get the instance of the map, Singleton Pattern
// only one map instance exists
Map* GetMapInstance()
{
    static Map* the_map = NULL;
    if (!the_map)
    {
	the_map = new Map();
    }
    return the_map;
}

// export c++ function and class to python
BOOST_PYTHON_MODULE(MyEngine)
{
    using namespace boost::python;
    def("GetMapInstance", GetMapInstance,
	return_value_policy< reference_existing_object >());
    class_<Map>("Map", "Game Map")
    	.def("Print", &Map::Print)
    	.def("SetPixel", &Map::SetPixel,
	    (arg("x"), "y", "val"));
}

int main()
{
    try
    {
	using namespace boost::python;

	InitPython();
	initMyEngine(); // init MyEngine Module

	// Add current path to sys.path. You have to
	// do this in linux. While in Windows,
	// current path is already in sys.path.
	object main_module = import( "__main__" );
	object main_namespace = main_module.attr( "__dict__" );
	object ignored = exec(
	    "import sys\n"
	    "sys.path.append('.')\n", main_namespace );

	Map* map = GetMapInstance();
	std::cout << "Before python\n";
	map->Print();

	// load python to design the map
	object mapMaker = import("mapmaker");
	object makeMap = mapMaker.attr("make_map");
	makeMap();

	std::cout << "\nAfter python\n";
	map->Print();
    }
    catch (...)
    {
	PyErr_Print();
    }

    return 0;
}

{% endcodeblock %}


Python写的地图生成程序：mapmaker.py。


{% codeblock python lang:python %}

import MyEngine
import random

def make_map():
    the_map = MyEngine.GetMapInstance()
    n = 10
    for i in range(n):
        for j in range(10 - i, 10 + i - 1):
            the_map.SetPixel(j, i, ord('*'))


{% endcodeblock %}


我们可以仔细看看C++和Python代码中被高亮的行（代码是js高亮的，如果还没高亮请稍等页面加载完成）。

C++通过Boost库可以方便地和Python交互。当然我们还可以直接是用解释器提供的C API的和Python交互，不过这样会有非常多的累赘的代码。

C++和Python交互的关键之处是通过BOOST_PYTHON_MODULE来导出C++的函数和类，此外还需要执行initMyEngine这个函数来将这个模块注册进Python解释器。具体细节可以见代码。

对于


> 

{% codeblock %}
 def("GetMapInstance", GetMapInstance,
	return_value_policy< reference_existing_object >());
{% endcodeblock %}




中的return_value_policy< reference_existing_object >()可以参考我以前写的：[http://blog.csdn.net/cedricporter/article/details/6828322](http://blog.csdn.net/cedricporter/article/details/6828322)


## 编译：




> g++ main.cpp -o map -I/usr/include/python2.7 -lboost_python -lpython2.7


在Windows上编译更容易，就不再罗嗦。

最后程序的输出，可以见到Python将地图由空白变成了一个三角形：

[![](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-03-210111.png)](http://everet.org/wp-content/uploads/2012/05/Screenshot-from-2012-05-03-210111.png)


## Example


对于用合适的语言来做合适的事情，会让开发效率和产品质量有所提高。例如，在Emacs里面，就可以是用lisp来控制emacs，AutoCAD中也可以是用脚本来绘图。这样的用户接口更加灵活。


## Other




### Scar


对于Scar这款3D太空：[http://www.everet.org/2012/01/scar.html](http://www.everet.org/2012/01/scar.html)，是用C++和Python混合编程。在Scar中的2D界面库，有C++写成的基本元件，例如容器和按钮。我们可以在Python中组装C++元件来装配游戏的2D界面，然后返回一棵树的根节点给C++。于是像Scar中的水平仪，提示面板，地图，血条等等都是在Python中组装好的。此外，我们还可以在Python中编写元件的事件处理函数。这样做的好处是，我们在修改界面的时候，不再需要重新编译程序，只要修改脚本就好。

这样的开发会更加便捷而且应对变更的能力会更强。


### ImaginationFactory


Imagination Factory是在大一的时候写的一个图像处理程序，[http://everet.org/2012/01/imagination-factory.html](http://everet.org/2012/01/imagination-factory.html)。

图像处理核心使用C++编写，界面使用C#/WPF编写。用WPF写界面即方便又便捷，可以轻松地实现很酷的效果。


### Clover —— Computer Simulation Origami


Clover是一款计算机模拟折纸的程序，主要程序使用C#编写，内嵌Python解释器，可以用Python折纸。
