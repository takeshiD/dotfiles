title: howtouse_ueberzugpp
====================================
date: 2024-07-05 10:06:24
tags: []
category: []
====================================

# about ueberzugpp
ueberzug is a image renderer in terminal emulator on graphical desktop, great tool.
however ueberzug is now stopped development. 

thus ueberzug is developped, instead of unberzug.

https://github.com/jstkdng/ueberzugpp.git


# usage
At first ueberzugpp starts as daemon, when ueberzugpp is recevied json-data via unix-socket, on terminal ueberzugpp draw specified image of path included in json-data.

## 1. Start up `uebergzugpp` daemon
execute following command for unberzugpp starting as daemon.

```bash
$ ueberzugpp layer
```

start other terminal, check exisiting `/tmp/ueberzugpp-*`.

```bash
$ ls -la /tmp/ueberzuggpp-*
srwxrwxr-x 1 tkcd tkcd    0  7月  5 11:25 /tmp/ueberzugpp-2188688.socket=
-rw-rw-r-- 1 tkcd tkcd 4954  7月  5 11:28 /tmp/ueberzugpp-tkcd.log
```

`/tmp/ueberzugpp-2188688.socket=` is unix-socket. if this file is existed, ueberzuggpp is running as daemon. good.


