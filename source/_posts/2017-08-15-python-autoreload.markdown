---
layout: post
title: "Python自动监控代码修改进行reload"
date: 2017-08-15 21:20
comments: true
categories: IT
tags: Python
---

最近在用 grpc[^1] ，发现 grpc 的 Python server 目前还没有像 Flask 那样的修改后自动 reload ，开发不是很方便。

所以就看看有什么比较好的实现，发现 werkzeug[^2] 已经有个比较好的实现，而且 Flask 用的就是它。就不用重复发明轮子了。

假设我们的启动 server 的代码写在了 `run_server` 里面，我们可以将其传入到 werkzeug 的 `run_with_reloader` ，就会拥有监控文件改变自动 reload 的功能。

<!-- more -->

``` python
from werkzeug._reloader import run_with_reloader

main_func = partial(run_server, grpc_host, grpc_port, concurrent)
if autoreload:
    run_with_reloader(main_func)
else:
    main_func()
```

## 原理

入口程序(主进程)进入 `run_with_reloader` 后，因为此时环境变量中没有 `WERKZEUG_RUN_MAIN`，所以不会运行主逻辑 `run_server` 。而是会取出自己的命令行参数，设置好 `WERKZEUG_RUN_MAIN` 环境变量，通过 subprocess 创建一个自己，这个时候子进程判断设置了 `WERKZEUG_RUN_MAIN`，此时才运行真正的程序逻辑。

werkzeug 的 reloader 封装了 Stat 和 WatchDog 两种 reloader ，当子进程监控到文件改变后，会调用 `trigger_reload` 退出自己。然后主进程判断特殊的返回码`3`后再次启动子进程。

从而完成了监控文件改变，自动 reload 自己的功能。

``` python
class ReloaderLoop(object):
    # ...
    def restart_with_reloader(self):
        """Spawn a new Python interpreter with the same arguments as this one,
        but running the reloader thread.
        """
        while 1:
            _log('info', ' * Restarting with %s' % self.name)
            args = _get_args_for_reloading()
            new_environ = os.environ.copy()
            new_environ['WERKZEUG_RUN_MAIN'] = 'true'

            # ...

            exit_code = subprocess.call(args, env=new_environ, close_fds=False)
            if exit_code != 3:
                return exit_code

    def trigger_reload(self, filename):
        self.log_reload(filename)
        sys.exit(3)


def run_with_reloader(main_func, extra_files=None, interval=1,
                      reloader_type='auto'):
    """Run the given function in an independent python interpreter."""
    import signal
    reloader = reloader_loops[reloader_type](extra_files, interval)
    signal.signal(signal.SIGTERM, lambda *args: sys.exit(0))
    try:
        if os.environ.get('WERKZEUG_RUN_MAIN') == 'true':
            t = threading.Thread(target=main_func, args=())
            t.setDaemon(True)
            t.start()
            reloader.run()
        else:
            sys.exit(reloader.restart_with_reloader())
    except KeyboardInterrupt:
        pass
```

## Links

[^1]: https://github.com/grpc/grpc

[^2]: werkzeug.pocoo.org