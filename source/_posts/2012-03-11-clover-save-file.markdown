---
comments: true
date: 2012-03-11 00:49:53
layout: post
slug: clover-save-file
title: Clover折纸数据结构的文件保存
wordpress_id: 672
categories:
- My Code
tags:
- Clover
- 数据结构
---

Clover的数据结构是由面层，边层和点层所组成。


## 面层


面层是一棵二叉树外加一个面组用于实现重叠的面的拾取和避免Z-Buffer失效。当发生折叠的时候，肯定至少有一个面会被分割成为两个面，所以二叉树的叶子增加两个节点，叶子更新，渲染层也需要更新。

[![facetree](http://everet.org/wp-content/uploads/2012/03/facetree_thumb.png)](http://everet.org/wp-content/uploads/2012/03/facetree.png)


## 




## 边层


边层是二叉树组成的森林，

[![facetree](http://everet.org/wp-content/uploads/2012/03/facetree_thumb1.png)](http://everet.org/wp-content/uploads/2012/03/facetree1.png)

<!-- more -->


## 点层


至于点层，就是十字链表。就是链表串着链表。当一个点的位置发生变化，它就会克隆一个自己向下插入到历史表中。有新的点产生时，则会向右边增加。这里是整个数据结构的核心，面层和边层只是对于点层的索引罢了。

我们在保存前会给顶点分配ID。

所以整个折纸过程都在这个数据结构里面。只要辅助我们精心设计的ShadowSystem，就可以Undo和Redo，甚至重放整个折纸过程。


## 




## 保存文件


现在我们的问题可以抽象为，保存面二叉树，边森林，和点十字链表，只是将他们保存到文件肯定很容易，但是如何将他们之间的关系保存到文件里面就是需要我们细细斟酌了。

今晚花了一整个晚上把保存文件和读取文件做了，借鉴了编译器的语法分析器的思想和关系数据库的表之间的关联的思想，来做文件的保存和读取。


### 文件格式文法




> **Clover**                –> VertexLayer EdgeLayer FaceLayer ShadowSytem

**ShadowSysem**->TrunkName num SnapshotNode*

**SnapshotNode**  -> type num face+ num edge* num vertex_id  originVertexListCount  originEdgeListCount

**VertexLayer**  -> TrunkName VertexTable vertex_count

**EdgeLayer**    -> TrunkName num EdgeTree+

**EdgeTree**       –> Edge+

**FaceLayer**     –> TrunkName FaceTree

**FaceTree**       –> Face+

**Edge**              –> edge_id vertex1_id vertex2_id

| –1

**Face**              –> face_id start_vertex1 start_vertex2 num edge_id+

| –1

**face_id**         -> positive_number

**edge_id**        -> positive_number


我使用自顶向下的语法分析方法，这样实现起来很快，也就是一大堆递归。

敏捷~

那么我们如何关联面和边,边和点呢? 这个借鉴了关系数据库的思想,使用主码来关联表,也就是我给边和点都分配了id后存入,这样读取的时候可以根据id来重建这些数据结构的联系.

再次印证了很多年前就被灌输的 程序=数据结构+算法 的思想了。

就是这么简单啦~~哇哈哈~~~~~
