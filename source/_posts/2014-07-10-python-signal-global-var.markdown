---
layout: post
title: "Python中使用signal带来的怪异问题"
date: 2014-07-10 18:40
comments: true
categories: IT
tags: [Python]
toc: true
---

今天智平在群里发了一个signal的考题考大家，就是下面程序是什么输出：

<!-- more -->

``` python
import signal
import sys

count = 0  

def signal_handler(signum, frame):
    global count
    count = -1
    print 'sig', count

def main():
    signal.signal(signal.SIGALRM, signal_handler)
    signal.setitimer(signal.ITIMER_REAL, 1, 1)
    global count
    while True:
        for line in sys.stdin:
            count += 1
            print count

if __name__ == "__main__":
    main()
```

然后执行`tail -f /home/logs/nginx/access.log | python a.py`，

问输出是 1，2，3，4，5，-1，6，7，8... 这样， 还是1，2，3，4，5，-1，0，1，2...

我们经过测试，是第一种情况。非常奇葩。

伟大的大神叠哥说道：

{% blockquote %}
count += 1 有 read count、plus 1、store count 三步，会不会是因为实现上的什么原因，那个signal_handler总是插入到这三个操作中间去执行了？

因为，发现在count += 1 前面加一条无意义的赋值语句，结果就符合预期了。就输出1，2，3，4，5，-1，0，1，2...

``` python
while True:
    for line in sys.stdin:
        x = count
        count += 1
        print count
```
{% endblockquote %}

为啥加上`x = count`，输出就变了呢？我觉得大神叠哥一语道出了问题的本质，于是想去求证一下是否真的如此：signal_handler总是插入到这三个操作中间去执行。

## 我们来看字节码

我们首先来看看signal_handler的字节码：

``` python
In [8]: dis.dis(signal_handler)
  3           0 LOAD_CONST               1 (-1)
              3 STORE_GLOBAL             0 (count)

  4           6 LOAD_CONST               2 ('sig')
              9 PRINT_ITEM
             10 LOAD_GLOBAL              0 (count)
             13 PRINT_ITEM
             14 PRINT_NEWLINE
             15 LOAD_CONST               0 (None)
             18 RETURN_VALUE
```

然后我们再看看两个程序main()的字节码。这里列出字节码主要供下一节参考使用，现在可以不用太仔细看。

### 非预期的程序

我们看看输出1，2，3，4，5，-1，6，7，8...的字节码

``` python
def main():
    signal.signal(signal.SIGALRM, signal_handler)
    signal.setitimer(signal.ITIMER_REAL, 1, 1)
    global count
    while True:
        for line in sys.stdin:
            count += 1
            print count
```

```
In [4]: dis.dis(main)
  2           0 LOAD_GLOBAL              0 (signal)
              3 LOAD_ATTR                0 (signal)
              6 LOAD_GLOBAL              0 (signal)
              9 LOAD_ATTR                1 (SIGALRM)
             12 LOAD_GLOBAL              2 (signal_handler)
             15 CALL_FUNCTION            2
             18 POP_TOP

  3          19 LOAD_GLOBAL              0 (signal)
             22 LOAD_ATTR                3 (setitimer)
             25 LOAD_GLOBAL              0 (signal)
             28 LOAD_ATTR                4 (ITIMER_REAL)
             31 LOAD_CONST               1 (1)
             34 LOAD_CONST               1 (1)
             37 CALL_FUNCTION            3
             40 POP_TOP

# while True:
  5          41 SETUP_LOOP              45 (to 89)
        >>   44 LOAD_GLOBAL              5 (True)
             47 POP_JUMP_IF_FALSE       88

# for line in sys.stdin:
  6          50 SETUP_LOOP              32 (to 85)
             53 LOAD_GLOBAL              6 (sys)
             56 LOAD_ATTR                7 (stdin)
             59 GET_ITER
        >>   60 FOR_ITER                21 (to 84)
             63 STORE_FAST               0 (line)
# count += 1
  7          66 LOAD_GLOBAL              8 (count)
             69 LOAD_CONST               1 (1)
             72 INPLACE_ADD
             73 STORE_GLOBAL             8 (count)
# print count
  8          76 LOAD_GLOBAL              8 (count)
             79 PRINT_ITEM
             80 PRINT_NEWLINE
             81 JUMP_ABSOLUTE           60  # 这里回到偏移60的指令
        >>   84 POP_BLOCK
        >>   85 JUMP_ABSOLUTE           44
        >>   88 POP_BLOCK
        >>   89 LOAD_CONST               0 (None)
             92 RETURN_VALUE
```

### 预期输出的程序
我们再来看看1，2，3，4，5，-1，0，1，2...的程序的字节码：

``` python
def main():
    signal.signal(signal.SIGALRM, signal_handler)
    signal.setitimer(signal.ITIMER_REAL, 1, 1)
    global count
    while True:
        for line in sys.stdin:
            x = count
            count += 1
            print count
```

```
In [6]: dis.dis(main)
  2           0 LOAD_GLOBAL              0 (signal)
              3 LOAD_ATTR                0 (signal)
              6 LOAD_GLOBAL              0 (signal)
              9 LOAD_ATTR                1 (SIGALRM)
             12 LOAD_GLOBAL              2 (signal_handler)
             15 CALL_FUNCTION            2
             18 POP_TOP

  3          19 LOAD_GLOBAL              0 (signal)
             22 LOAD_ATTR                3 (setitimer)
             25 LOAD_GLOBAL              0 (signal)
             28 LOAD_ATTR                4 (ITIMER_REAL)
             31 LOAD_CONST               1 (1)
             34 LOAD_CONST               1 (1)
             37 CALL_FUNCTION            3
             40 POP_TOP
# while True:
  5          41 SETUP_LOOP              51 (to 95)
        >>   44 LOAD_GLOBAL              5 (True)
             47 POP_JUMP_IF_FALSE       94
# for line in sys.stdin:
  6          50 SETUP_LOOP              38 (to 91)
             53 LOAD_GLOBAL              6 (sys)
             56 LOAD_ATTR                7 (stdin)
             59 GET_ITER
        >>   60 FOR_ITER                27 (to 90)
             63 STORE_FAST               0 (line)
# x = count
  7          66 LOAD_GLOBAL              8 (count)
             69 STORE_FAST               1 (x)
# count += 1
  8          72 LOAD_GLOBAL              8 (count)
             75 LOAD_CONST               1 (1)
             78 INPLACE_ADD
             79 STORE_GLOBAL             8 (count)
# print count
  9          82 LOAD_GLOBAL              8 (count)
             85 PRINT_ITEM
             86 PRINT_NEWLINE
             87 JUMP_ABSOLUTE           60
        >>   90 POP_BLOCK
        >>   91 JUMP_ABSOLUTE           44
        >>   94 POP_BLOCK
        >>   95 LOAD_CONST               0 (None)
             98 RETURN_VALUE
```

## 增加调试代码

有了程序的字节码后，我们需要打印一下程序的执行流程，来深入看看究竟发生了啥事。我们可以先下载[Python 2.7.3](https://www.python.org/download/releases/2.7.3/)的源代码回来，然后修改：

首先打印处理的字节码，我们打开`Python/ceval.c`，在下面`PyEval_EvalFrameEx`中的`swtich (opcode)`，前面加上`printf("[opcode: %d]\n", opcode);`来打印处理的opcode。

然后我们修改一下signalmodule模块，在处理signal的时候，打印一条log。我们打开`Modules/signalmodule.c`，在其中的`PyErr_CheckSignals`里面的`result = PyEval_CallObject(Handlers[i].func, arglist);`语句前加上`printf("-> call signal handler\n");`，这样就可以在调用signal handler的时候打印一条log。

然后就是编译Python了。编译完，我们就用编译好的Python来做实验！Yeah~

## 打印程序执行流程

接下来，我们就执行这怪异的程序，我们先来看看输出1，2，3，4，5，-1，6，7，8...这个不符合预期的程序的字节码处理流程[^1]

### 非预期版本的执行流程

```
[opcode: 113 JUMP_ABSOLUTE] 
[opcode: 93 FOR_ITER] 

[opcode: 116 LOAD_GLOBAL]
[opcode: 100 LOAD_CONST] 
[opcode: 55 INPLACE_ADD] 
[opcode: 97 STORE_GLOBAL]

[opcode: 116 LOAD_GLOBAL]
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 113 JUMP_ABSOLUTE]

[opcode: 93 FOR_ITER]       
[opcode: 116 LOAD_GLOBAL]   # 将count压入栈

-> call signal handler
[opcode: 100 LOAD_CONST]    # 这里进入到了signal_handler
[opcode: 97 STORE_GLOBAL]   # count = -1
[opcode: 100 LOAD_CONST]   
[opcode: 71 PRINT_ITEM]
[opcode: 116 LOAD_GLOBAL]
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 100 LOAD_CONST]
[opcode: 83 RETURN_VALUE]

[opcode: 100 LOAD_CONST]   # 回到main
[opcode: 55 INPLACE_ADD]   # 将之前栈顶的count+1，存到全局中的count
[opcode: 97 STORE_GLOBAL]

[opcode: 116 LOAD_GLOBAL]  
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 113 JUMP_ABSOLUTE] 
```

经过几十秒后，我们可以看到，除了第一次外，后续的signal handler，都在同一个地方被调用的：

```
[opcode: 93 FOR_ITER]       
[opcode: 116 LOAD_GLOBAL]   # 将count压入栈

-> call signal handler
```

这里解释器刚刚将全局的count压入栈，就切换到signal handler处理。

所以这里可以出现问题的原因就很明显了。在main()中，已经将全局的count压入栈，而切换到`signal_handler`中，修改了全局的count为-1，也是无意义的。因为切回到main()的时候，是操作的是栈顶部的count副本，栈顶+1后，将栈顶的值又写入全局的count中，就把`signal_handler`设置的count=-1给覆盖了。所以就会一直递增下去。

### 可预测版本的执行流程

```
[opcode: 113 JUMP_ABSOLUTE] 
[opcode: 93 FOR_ITER] 

[opcode: 116 LOAD_GLOBAL]
[opcode: 125 STORE_FAST]
[opcode: 116 LOAD_GLOBAL]
[opcode: 100 LOAD_CONST]
[opcode: 55 INPLACE_ADD]
[opcode: 97 STORE_GLOBAL]
[opcode: 116 LOAD_GLOBAL]
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 113 JUMP_ABSOLUTE]

[opcode: 93 FOR_ITER]
[opcode: 116 LOAD_GLOBAL] # 将全局count压入栈顶

-> call signal handler
[opcode: 100 LOAD_CONST]   # 进入signal handler
[opcode: 97 STORE_GLOBAL]
[opcode: 100 LOAD_CONST]
[opcode: 71 PRINT_ITEM]
[opcode: 116 LOAD_GLOBAL]
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 100 LOAD_CONST]
[opcode: 83 RETURN_VALUE]

[opcode: 125 STORE_FAST]   # 回到main(), x = 栈顶
[opcode: 116 LOAD_GLOBAL]  # 又将全局count压入栈，此时的全局的count是-1
[opcode: 100 LOAD_CONST]  # 继续压入1
[opcode: 55 INPLACE_ADD]  # 栈顶的两个值求和，count+1
[opcode: 97 STORE_GLOBAL] # 将栈顶的值写到全局count中，此时全局count为0

[opcode: 116 LOAD_GLOBAL]
[opcode: 71 PRINT_ITEM]
[opcode: 72 PRINT_NEWLINE]
[opcode: 113 JUMP_ABSOLUTE]
```

我们可以看到，返回main()后，x是旧值，不过在`count += 1`的时候，又重新从全局字典中读取了count，所以此时的count是正确的。

于是这就解释了上述两程序的怪异行为。

## 新的疑问

于是这里又引入了一个新的疑问，为什么每次signal handler都在同一个指令后触发？嗯，这个我们就需要去看看Python解释器的实现。我们首先看看signal是怎么触发的。

### signal

我们打开`Modules/signalmodule.c`，这个是signal模块的实现。

``` c
static void
trip_signal(int sig_num)
{
    Handlers[sig_num].tripped = 1;
    if (is_tripped)
        return;
    /* Set is_tripped after setting .tripped, as it gets
       cleared in PyErr_CheckSignals() before .tripped. */
    is_tripped = 1;
    Py_AddPendingCall(checksignals_witharg, NULL);
    if (wakeup_fd != -1)
        write(wakeup_fd, "\0", 1);
}
```

其中，当signal触发的时候，我们看到，Python解释器不是马上调用我们的signal handler，而是调用`Py_AddPendingCall`，将我们回调加到pendingcalls中，然后让主线程在适当的时机调用。最后会调用到`PyErr_CheckSignals`，然后在里面根据不同的signal选择不同的handler来调用。

### 什么时候signal handler被调用？

刚刚我们看到，signal触发的时候，会调用`Py_AddPendingCall`会事件处理加到pendingcalls中（`Py_AddPendingCall`除了会将函数放到pendingcall队列中，还会将`_Py_Ticker`设置为0，以通知主线程尽快执行pendingcalls。）。那么pendingcalls中的函数什么时候调用呢？

我们首先来到Python解释器的核心函数`PyEval_EvalFrameEx`（在`Python/ceval.c`），看到其中有调用`Py_MakePendingCalls`，这个里面调用了pendingcalls。

``` c
PyObject *
PyEval_EvalFrameEx(PyFrameObject *f, int throwflag)
{
    // ...

    for (;;) {
        if (--_Py_Ticker < 0) {
            _Py_Ticker = _Py_CheckInterval;
            Py_MakePendingCalls();
        }

    fast_next_opcode:
        opcode = NEXTOP();

        switch (opcode) {
        PREDICTED_WITH_ARG(FOR_ITER);
        case FOR_ITER:
            // ....
            PREDICT(STORE_FAST);
            // ...
            continue;
        PREDICTED_WITH_ARG(STORE_FAST);
        case STORE_FAST:
            v = POP();
            SETLOCAL(oparg, v);
            goto fast_next_opcode;
        case JUMP_ABSOLUTE:
            JUMPTO(oparg);
            goto fast_next_opcode;

        // case ...
        } 
    } /* main loop */

    // ...

    return retval;
}
```

也就是每次循环开的时候，当`_Py_Ticker < 0`的时候，就会调用`Py_MakePendingCalls`，里面会调用我们pending的signal handler。

### 那么为啥都是那个时刻调用呢？

我可以告诉你，这个真的是纯属巧合。不过为啥在下面三条指令后，触发signal handler的概率那么高呢？

```
[opcode: 113 JUMP_ABSOLUTE] ; goto fast_next_opcode;
[opcode: 93 FOR_ITER]       ; PREDICT(STORE_FAST); goto fast_next_opcode;
[opcode: 116 LOAD_GLOBAL]   # 取出全局变量，这个操作相对来时是非常费时
-> call signal handler
```

如果我们仔细去看`PyEval_EvalFrameEx`主循环中指令的解释，会看到其中会有优化。其中就有`PREDICT`和`fast_next_opcode`[^2]，当`PREDICT`下一条指令成功的时候，会直接goto到下一条指令的处理代码，就不会回到主循环的开头。而`fast_next_opcode`，也跳过了延迟任务的检查。

而我们上面3个指令的执行，是通过加速，中间都是直接goto执行下一条，一直没有回到主循环开始，所以就没有机会检查`_Py_Ticker`和执行`Py_MakePendingCalls`。而这段连续的时间相对较长，signal在这段时间触发设置`_Py_Ticker`为0的概率最大。

## 再验证！

既然是巧合，那么就是说，输出1，2，3，4，5，-1，6，7，8...的程序，其实还是有可能在signal handler成功重置计数咯？

于是我将第一个程序放置在那里跑，跑了好久，当计数记到40多万的时候，终于计数重置为0了。也就是说，之前能够连续计数，这个纯属巧合，只是偶然signal_handler都在同一个错误的地方执行。

不过智平童鞋竟然可以写出如此神奇的代码，说明rp十分之高！！

因为时间仓促，语言可能有些混乱，还请见谅。

最后，还是非常佩服伟大的叠哥大神一遇道破天机！！


[^1]: 输出的字节码指令是数字，还需要另外翻译一下，如果你用Emacs，可以使用这个[gist](https://gist.github.com/cedricporter/311fbb59e1fb26c4f480)，会自动翻译上面输出的opcode。如果不是，可以自己根据源码中的opcode.py修改一下。

[^2]: 更多解释可以自己看源码和《Python源码剖析》
