---
comments: true
date: 2012-03-03 23:38:58
layout: post
slug: c-template
title: C#的模板
wordpress_id: 635
categories:
- My Code
---

一个很2B的求两个List的差集的作为示例


{% codeblock cpp lang:cpp %}

        List<T> Minus<T>(List<T> list1, List<T> list2)
        {
            List<T> ret = new List();

            foreach (T e in list1)
            {
                if (!list2.Contains(e))
                {
                    ret.Add(e);
                }
            }

            return ret;
        }

{% endcodeblock %}


当然地球人会这样写:


> List<Edge> beDeletedEdges = currentEdgeList.Except(originEdgeList).ToList();


好吧，我喜欢把C#当Python写......
