# filerun

## advise

filerun 如果用 docker 运行，软链接将链接到 docker 环境的路径下，

除非将软链的路径原原本本地挂载到 docker 文件系统，否则软链将无法使用

因此不推荐使用 docker 进行安装
