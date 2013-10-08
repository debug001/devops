Repcached(Memcached) Memslap性能压力测试 Step 3
=============================================

概述:
------
1. 首先完成[Repcached(Memcached)编译测试 Step 1](https://github.com/debug001/devops/blob/master/Repcached(Memcached)%20%E7%BC%96%E8%AF%91%E6%B5%8B%E8%AF%95%20Step1.md)。
2. 原生Memcached和Repcached基准测试数据对比（1k-10k)压测。
3. 使用Memslap。
	简介：
	Memslap:libmemcached自带的压测工具，[英文说明文档](http://www.krow.net/libmemcached/memslap.html).


环境：
------
	Centos 6.4 x86 (openvz) 
	MEM:8G
	CPU:E5620*16
	libevent-devel
	memcached-1.2.8-repcached-2.2.1.tar.gz
	memcached
	libmemcached


依赖：
------
1. git

	[root@xifan-nosql ~]# cd /home/zxl/packages/
	[root@xifan-nosql packages]# pwd
	/home/zxl/packages
	[root@xifan-nosql packages]# yum install -y git memcahed
	
2. autoreconf >= 2.65

	[root@xifan-nosql packages]# rpm -qf /usr/bin/autoconf
	autoconf-2.63-5.1.el6.noarch
	[root@xifan-nosql packages]# wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
	[root@xifan-nosql packages]# tar -xzvf autoconf-2.69.tar.gz
	[root@xifan-nosql packages]# cd autoconf-2.69
	[root@xifan-nosql autoconf-2.69]# ./configure --prefix=/usr &&　make && make install
	[root@xifan-nosql autoconf-2.69]# /usr/bin/autoconf -V
	autoconf (GNU Autoconf) 2.69
	Copyright (C) 2012 Free Software Foundation, Inc.
	License GPLv3+/Autoconf: GNU GPL version 3 or later
	<http://gnu.org/licenses/gpl.html>, <http://gnu.org/licenses/exceptions.html>
	This is free software: you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.

	Written by David J. MacKenzie and Akim Demaille.

编译安装mcperf：	
------------------

	[root@xifan-nosql ~]#  mkdir /home/zxl/packages -p
	[root@xifan-nosql ~]#  cd /home/zxl/packages
	[root@xifan-nosql zxl]# git clone git://github.com/twitter/twemperf.git
	[root@xifan-nosql packages]# cd twemperf
	[root@xifan-nosql twemperf]# autoreconf -fvi
	[root@xifan-nosql twemperf]# CFLAGS="-ggdb3 -O0" ./configure --enable-debug
	[root@xifan-nosql twemperf]# make
	[root@xifan-nosql twemperf]# src/mcperf -h
	This is mcperf-0.1.1

	Usage: mcperf [-?hV] [-v verbosity level] [-o output file]
	              [-s server] [-p port] [-H] [-t timeout] [-l linger]
	              [-b send-buffer] [-B recv-buffer] [-D]
	              [-m method] [-e expiry] [-q] [-P prefix]
	              [-c client] [-n num-conns] [-N num-calls]
	              [-r conn-rate] [-R call-rate] [-z sizes]

	Options:
	  -h, --help            : this help
	  -V, --version         : show version and exit
	  -v, --verbosity=N     : set logging level (default: 5, min: 0, max: 11)
	  -o, --output=S        : set logging file (default: stderr)
	  -s, --server=S        : set the hostname of the server (default: localhost)
	  -p, --port=N          : set the port number of the server (default: 11211)
	  -H, --print-histogram : print response time histogram
	  ...
	  -t, --timeout=X       : set the connection and response timeout in sec (default: 0.0 sec)
	  -l, --linger=N        : set the linger timeout in sec, when closing TCP connections (default: off)
	  -b, --send-buffer=N   : set socket send buffer size (default: 4096 bytes)
	  -B, --recv-buffer=N   : set socket recv buffer size (default: 16384 bytes)
	  -D, --disable-nodelay : disable tcp nodelay
	  ...
	  -m, --method=M        : set the method to use when issuing memcached request (default: set)
	  -e, --expiry=N        : set the expiry value in sec for generated requests (default: 0 sec)
	  -q, --use-noreply     : set noreply for generated requests
	  -P, --prefix=S        : set the prefix of generated keys (default: mcp:)
	  ...
	  -c, --client=I/N      : set mcperf instance to be I out of total N instances (default: 0/1)
	  -n, --num-conns=N     : set the number of connections to create (default: 1)
	  -N, --num-calls=N     : set the number of calls to create on each connection (default: 1)
	  -r, --conn-rate=R     : set the connection creation rate (default: 0 conns/sec) 
	  -R, --call-rate=R     : set the call creation rate (default: 0 calls/sec)
	  -z, --sizes=R         : set the distribution for item sizes (default: d1 bytes)
	  ...
	Where:
	  N is an integer
	  X is a real
	  S is a string
	  M is a method string and is either a 'get', 'gets', 'delete', 'cas', 'set', 'add', 'replace'
	  'append', 'prepend', 'incr', 'decr'
	  R is the rate written as [D]R1[,R2] where:
	  D is the distribution type and is either deterministic 'd', uniform 'u', or exponential 'e' and if:
	  D is ommited or set to 'd', a deterministic interval specified by parameter R1 is used
	  D is set to 'e', an exponential distibution with mean interval of R1 is used
	  D is set to 'u', a uniform distribution over interval [R1, R2) is used
	  R is 0, the next request or connection is created after the previous one completes

编译安装mcperf：	
------------------

压测命令解释：
--------------

	[root@xifan-nosql twemperf]# src/mcperf -s 172.16.138.88 -p 11211 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10000 --num-conns=100 --sizes=u1024,10240
	
	--num-conns=100是并发创建100個连接；--num-calls=10000是在一個连接上并发1w个请求；--sizes=u1024,10240是数据大小在1k和10k之随机分布；-conn-rate=1000是1秒钟建立1000个连接

	

Check Repcached(Memcached) Replication:
----------------------------

	#Master
	[root@xifan-nosql bin]# telnet 127.0.0.1 11211
	Trying 127.0.0.1...
	Connected to 127.0.0.1.
	Escape character is '^]'.
	set key1 0 0 3
	111
	STORED
	get key2
	END
	get key2
	VALUE key2 0 3
	222
	END
	get key3
	VALUE key3 0 4
	3333
	END
	set key5 0 0 5
	99999
	STORED
	
	#Slave
	[root@xifan-nosql ~]# telnet 127.0.0.1 11213
	Trying 127.0.0.1...
	Connected to 127.0.0.1.
	Escape character is '^]'.
	get key1
	VALUE key1 0 3
	111
	END
	set key2 0 0 3
	222
	STORED
	set key3 0 0 4
	3333
	STORED
	get key5
	VALUE key5 0 5
	99999
	END
	
------
#注意:
------
	* 上述测试表示，Repcached可以实现Memcached数据双向复制。
	* 测试发现，Repcached中Master、Slave任何一个挂了，都能正常提供服务。并且服务重启后会自动同步数据。
	* 只能支持Master与Slave（两个实例中）进行数据同步，超过两个会导致数据同步失败，原因是数据复制监听端口11212会被第三个进程占用（replication: failed to initialize replication server socket），重启后无法正常监听数据同步端口。
	* Repcached稳定性、大数据写入并发性、Repcliation数据一直性等场景还需要测试。
