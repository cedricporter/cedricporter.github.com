---
layout: post
title: "json注释？"
date: 2013-11-21 21:17
comments: true
categories: IT
tags: [Javascript, seajs]
---

今天好累啊。去以14.4km/h跑了1km后立马就灰常精神了。

今天我们的服务器几乎挂掉了，导致外部基本无法访问，下午得知的是内存爆了。作为新人，暂时只能围观。

俊伟哥开始关闭了一些服务，但是隔了一会还是又过载了。查了许久，最后发现paas平台igor今天切换到了lvs，我们的系统有使用igor里面的服务，又和igor在同一个lvs，结果导致lvs后的机又去访问同一个lvs，就出问题了。

--- 分割线 ---

回到主题， 前几天非常无聊，把一个项目的seajs拷贝了过来，结果在编译的时候报如下的错误。


<!-- more -->

```
/home/cedricporter/npm/lib/node_modules/spm-build/node_modules/spm-grunt/node_modules/grunt/lib/grunt/file.js:252
    throw grunt.util.error('Unable to parse "' + filepath + '" file (' + e.mes
                     ^
Error: Unable to parse "package.json" file (Unexpected token /).
    at Object.util.error (/home/cedricporter/npm/lib/node_modules/spm-build/node_modules/spm-grunt/node_modules/grunt/lib/grunt/util.js:57:39)
    at Object.file.readJSON (/home/cedricporter/npm/lib/node_modules/spm-build/node_modules/spm-grunt/node_modules/grunt/lib/grunt/file.js:252:22)
    at parseOptions (/home/cedricporter/npm/lib/node_modules/spm-build/index.js:96:22)
    at module.exports (/home/cedricporter/npm/lib/node_modules/spm-build/index.js:18:13)
    at Object.<anonymous> (/home/cedricporter/npm/lib/node_modules/spm-build/bin/spm-build:50:1)
    at Module._compile (module.js:456:26)
    at Object.Module._extensions..js (module.js:474:10)
    at Module.load (module.js:356:32)
    at Function.Module._load (module.js:312:12)
    at Function.Module.runMain (module.js:497:10)
```

但是seajs的demo是可以编译通过的啊！

搞了好久，发现我在package.json里面用`//`注释掉了一行，而**json里面不能有注释**，我X。去掉注释就好了。

真是问题越奇葩，原因越傻逼！

那么json里面怎么写注释呢？在stackoverflow上看到[^1]，可以增加一个`__comment`属性，然后在里面写注释。不过这样注释就会和数据搅到一起了，所以还是不要在json里面写注释比较好。

[^1]: [Can I comment a JSON file?](http://stackoverflow.com/questions/244777/can-i-comment-a-json-file)
