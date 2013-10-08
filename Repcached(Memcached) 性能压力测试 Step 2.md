Repcached(Memcached) mcperf性能压力测试 Step 2
============================================

概述:
------
1. 首先完成[Repcached(Memcached)编译测试 Step 1](https://github.com/debug001/devops/blob/master/Repcached\(Memcached\)%20%E7%BC%96%E8%AF%91%E6%B5%8B%E8%AF%95%20Step1.md)。
2. 原生Memcached和Repcached基准测试数据对比（1k-10k)压测。
3. 使用Mcperf、Memslap。
	简介：
	Mcperf:最初是twitter为了證明其Twemcache在特定場景下（需要自動調節slab大小的場景下）比memcached強悍而開發的基准壓測工具。比如在[Random Eviciton vs Slab Automove](https://github.com/twitter/twemcache/wiki/Random-Eviciton-vs-Slab-Automove)一文中，就使用了mcperf作为基准壓測工具。
	Memslap:[libmemcached](https://launchpad.net/libmemcached/1.0/1.0.17/+download/libmemcached-1.0.17.tar.gz)自带的压测工具，[英文说明文档](http://www.krow.net/libmemcached/memslap.html).


环境：
------
	Centos 6.4 x86 (openvz) 
	MEM:8G
	CPU:E5620*16
	libevent-devel
	memcached-1.4.4 (yum install)
	memcached-1.2.8-repcached-2.2.1.tar.gz
	mcperf
	autoreconf >= 2.65
	phpMemcachedAdmin

依赖：
------
1. git

	[root@xifan-nosql ~]# cd /home/zxl/packages/
	[root@xifan-nosql packages]# pwd
	/home/zxl/packages
	[root@xifan-nosql packages]# yum install -y git memcached httpd php-pecl-memcached.x86_64 php-pecl-memcache.x86_64 phpMemcachedAdmin.noarch
	
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

压测命令解释：
-----------

	[root@xifan-nosql twemperf]# ./src/mcperf -s 127.0.0.1 -p 11211 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10000 --num-conns=100 --sizes=u1024,10240
	
	--num-conns=100是并发创建100個连接；--num-calls=10000是在一個连接上并发1w个请求；--sizes=u1024,10240是数据大小在1k和10k之随机分布；-conn-rate=1000是1秒钟建立1000个连接

环境压测：
--------
启动memcache和Repcached 各分配1G内存
	* [root@xifan-nosql ~]# memcached -d -p 11211 -u memcached -m 1024 -c 65535 -P /var/run/memcached/memcached.pid
	* [root@xifan-nosql ~]# repcached -d -p 11213 -u memcached -m 1024 -c 65535 -P /var/run/memcached/repcachedM.pid -x 127.0.0.1 -X 11212
	* [root@xifan-nosql ~]# repcached -d -p 11214 -u memcached -m 1024 -c 65535 -P /var/run/memcached/repcachedS.pid -x 127.0.0.1 -X 11212

查看Memcached(Repcached)设置，maxconns(允许最大连接数)和evictions：

	[root@xifan-nosql ~]# for i in {11211,11213,11214};do echo -e "\n Host:" 127.0.0.1:$i "\n"; printf "stats \r\n" | nc 127.0.0.1 $i;done       

	 Host: 127.0.0.1:11211 

	STAT pid 11352
	STAT uptime 90
	STAT time 1381207062
	STAT version 1.4.4
	STAT pointer_size 64
	STAT rusage_user 0.002999
	STAT rusage_system 0.009998
	STAT curr_connections 10
	STAT total_connections 41
	STAT connection_structures 11
	STAT cmd_get 0
	STAT cmd_set 0
	STAT cmd_flush 0
	STAT get_hits 0
	STAT get_misses 0
	STAT delete_misses 0
	STAT delete_hits 0
	STAT incr_misses 0
	STAT incr_hits 0
	STAT decr_misses 0
	STAT decr_hits 0
	STAT cas_misses 0
	STAT cas_hits 0
	STAT cas_badval 0
	STAT auth_cmds 0
	STAT auth_errors 0
	STAT bytes_read 389
	STAT bytes_written 18429
	STAT limit_maxbytes 1073741824
	STAT accepting_conns 1
	STAT listen_disabled_num 0
	STAT threads 4
	STAT conn_yields 0
	STAT bytes 0
	STAT curr_items 0
	STAT total_items 0
	STAT evictions 0
	END

	 Host: 127.0.0.1:11213 

	STAT pid 10862
	STAT uptime 2227
	STAT time 1381207063
	STAT version 1.2.8
	STAT pointer_size 64
	STAT rusage_user 0.047992
	STAT rusage_system 0.039993
	STAT curr_items 2
	STAT total_items 2
	STAT bytes 144
	STAT curr_connections 7
	STAT total_connections 125
	STAT connection_structures 8
	STAT cmd_flush 0
	STAT cmd_get 1
	STAT cmd_set 2
	STAT get_hits 1
	STAT get_misses 0
	STAT evictions 0
	STAT bytes_read 1095
	STAT bytes_written 71568
	STAT limit_maxbytes 1073741824
	STAT threads 2
	STAT accepting_conns 1
	STAT listen_disabled_num 0
	STAT replication MASTER
	STAT repcached_version 2.2.1
	STAT repcached_qi_free 8191
	STAT repcached_wdata 0
	STAT repcached_wsize 2048
	END

	 Host: 127.0.0.1:11214 

	STAT pid 10864
	STAT uptime 2222
	STAT time 1381207063
	STAT version 1.2.8
	STAT pointer_size 64
	STAT rusage_user 0.050992
	STAT rusage_system 0.034994
	STAT curr_items 2
	STAT total_items 2
	STAT bytes 144
	STAT curr_connections 8
	STAT total_connections 104
	STAT connection_structures 9
	STAT cmd_flush 0
	STAT cmd_get 1
	STAT cmd_set 2
	STAT get_hits 1
	STAT get_misses 0
	STAT evictions 0
	STAT bytes_read 871
	STAT bytes_written 57909
	STAT limit_maxbytes 1073741824
	STAT threads 2
	STAT accepting_conns 1
	STAT listen_disabled_num 0
	STAT replication MASTER
	STAT repcached_version 2.2.1
	STAT repcached_qi_free 8191
	STAT repcached_wdata 0
	STAT repcached_wsize 2048
	END

*mcperf 100并发压测
	[root@xifan-nosql twemperf]# ./src/mcperf -s 127.0.0.1 -p 11211 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10000 --num-conns=100 --sizes=u1024,10240
	[Tue Oct  8 00:40:03 2013] mcp_conn_generator.c:64 created 0 100 of 100 connections
	[Tue Oct  8 00:40:22 2013] mcp_conn_generator.c:94 destroyed 100 of 100 of 100 connections

	Total: connections 100 requests 1000000 responses 1000000 test-duration 18.446 s

	Connection rate: 5.4 conn/s (184.5 ms/conn <= 100 concurrent connections)
	Connection time [ms]: avg 18068.2 min 17373.9 max 18438.6 stddev 264.28
	Connect time [ms]: avg 4.0 min 0.1 max 12.3 stddev 3.59

	Request rate: 54213.4 req/s (0.0 ms/req)
	Request size [B]: avg 5661.8 min 1054.0 max 10271.0 stddev 2658.17

	Response rate: 54213.4 rsp/s (0.0 ms/rsp)
	Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.00
	Response time [ms]: avg 5.5 min 0.1 max 67.9 stddev 0.00
	Response time [ms]: p25 3.0 p50 5.0 p75 6.0
	Response time [ms]: p95 11.0 p99 18.0 p999 39.0
	Response type: stored 1000000 not_stored 0 exists 0 not_found 0
	Response type: num 0 deleted 0 end 0 value 0
	Response type: error 0 client_error 0 server_error 0

	Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
	Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0

	CPU time [s]: user 4.02 system 14.37 (user 21.8% system 77.9% total 99.7%)
	Net I/O: bytes 5.3 GB rate 300173.0 KB/s (2459.0*10^6 bps)

	[root@xifan-nosql twemperf]# ./src/mcperf -s 127.0.0.1 -p 11213 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10000 --num-conns=100 --sizes=u1024,10240
	[Tue Oct  8 00:40:45 2013] mcp_conn_generator.c:64 created 0 100 of 100 connections
	[Tue Oct  8 00:41:14 2013] mcp_conn_generator.c:94 destroyed 100 of 100 of 100 connections

	Total: connections 100 requests 1000000 responses 1000000 test-duration 29.064 s

	Connection rate: 3.4 conn/s (290.6 ms/conn <= 100 concurrent connections)
	Connection time [ms]: avg 28178.9 min 24087.3 max 29059.8 stddev 843.12
	Connect time [ms]: avg 0.3 min 0.1 max 0.6 stddev 0.11

	Request rate: 34407.2 req/s (0.0 ms/req)
	Request size [B]: avg 5661.8 min 1054.0 max 10271.0 stddev 2658.17

	Response rate: 34407.2 rsp/s (0.0 ms/rsp)
	Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.00
	Response time [ms]: avg 15.4 min 0.0 max 1534.8 stddev 0.06
	Response time [ms]: p25 1.0 p50 1.0 p75 4.0
	Response time [ms]: p95 73.0 p99 223.0 p999 742.0
	Response type: stored 1000000 not_stored 0 exists 0 not_found 0
	Response type: num 0 deleted 0 end 0 value 0
	Response type: error 0 client_error 0 server_error 0

	Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
	Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0

	CPU time [s]: user 4.55 system 13.22 (user 15.6% system 45.5% total 61.1%)
	Net I/O: bytes 5.3 GB rate 190508.6 KB/s (1560.6*10^6 bps)


	[root@xifan-nosql twemperf]# ./src/mcperf -s 127.0.0.1 -p 11214 --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10000 --num-conns=100 --sizes=u1024,10240
	[Tue Oct  8 00:41:23 2013] mcp_conn_generator.c:64 created 0 100 of 100 connections
	[Tue Oct  8 00:41:46 2013] mcp_conn_generator.c:94 destroyed 100 of 100 of 100 connections

	Total: connections 100 requests 1000000 responses 1000000 test-duration 22.766 s

	Connection rate: 4.4 conn/s (227.7 ms/conn <= 100 concurrent connections)
	Connection time [ms]: avg 21818.4 min 18995.0 max 22758.1 stddev 811.62
	Connect time [ms]: avg 0.5 min 0.1 max 16.4 stddev 1.61

	Request rate: 43925.0 req/s (0.0 ms/req)
	Request size [B]: avg 5661.8 min 1054.0 max 10271.0 stddev 2658.17

	Response rate: 43925.0 rsp/s (0.0 ms/rsp)
	Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.00
	Response time [ms]: avg 6.7 min 0.0 max 233.7 stddev 0.01
	Response time [ms]: p25 1.0 p50 1.0 p75 8.0
	Response time [ms]: p95 27.0 p99 52.0 p999 119.0
	Response type: stored 1000000 not_stored 0 exists 0 not_found 0
	Response type: num 0 deleted 0 end 0 value 0
	Response type: error 0 client_error 0 server_error 0

	Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
	Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0

	CPU time [s]: user 4.23 system 11.88 (user 18.6% system 52.2% total 70.8%)
	Net I/O: bytes 5.3 GB rate 243207.8 KB/s (1992.4*10^6 bps)

MemCached性能监控工具
1. memcached-tool

	主要用於查看slab分配的情況，evction的情況。
	https://github.com/memcached/memcached/blob/master/scripts/memcached-tool
	[root@xifan-nosql packages]#  ./memcached-tool localhost:11213          
	  #  Item_Size  Max_age   Pages   Count   Full?  Evicted Evict_Time OOM
	 12     1.3K       137s       4    3048     yes    94358        4    0
	 13     1.7K       137s       6    3653     yes   119959        4    0
	 14     2.1K       137s       9    4383     yes   150962        4    0
	 15     2.6K       135s      13    5043     yes   191309        2    0
	 16     3.3K       135s      20    6200     yes   238330        2    0
	 17     4.1K       135s      32    7936     yes   297840        2    0
	 18     5.2K       135s      49    9702     yes   372036        2    0
	 19     6.4K       135s      77   12166     yes   463506        2    0
	 20     8.1K       135s     118   14986     yes   582541        2    0
	 21    10.1K       135s     184   18583     yes   723759        2    0
	 22    12.6K       151s       1      53      no        0        0    0


2. memcache-top
	用于查看吞吐量和hits情况
	https://memcache-top.googlecode.com/files/memcache-top-v0.6
	[root@xifan-nosql packages]# wget https://memcache-top.googlecode.com/files/memcache-top-v0.6
	[root@xifan-nosql packages]# chmod +x memcache-top-v0.6 
	[root@xifan-nosql packages]# ./memcache-top-v0.6 
	Can't locate Time/HiRes.pm in @INC (@INC contains: /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at ./memcache-top-v0.6 line 59.
	BEGIN failed--compilation aborted at ./memcache-top-v0.6 line 59.
	[root@xifan-nosql packages]# yum install -y perl-CPAN.x86_64 
	[root@xifan-nosql packages]# perl -MCPAN -e shell install Time/HiRes
	[root@xifan-nosql packages]# ./memcache-top-v0.6  --instance  127.0.0.1 --port 11213  
	memcache-top v0.6       (default port: 11213, color: on, refresh: 3 seconds)

	INSTANCE                USAGE   HIT %   CONN    TIME    EVICT/s READ/s  WRITE/s
	127.0.0.1:11213         89.7%   0.0%    1007    1.16s   34.3K   0.2G    285.5K  

	AVERAGE:                89.7%   0.0%    1007    1.16s   34.3K   0.2G    285.5K

	TOTAL:          0.4GB/  0.5GB           1007    1.16s   34.3K   0.2G    285.5K

3. phpMemcachedAdmin 

4. memadmin
	https://github.com/debug001/memadmin

5. libmemcached
	[root@xifan-nosql packages]# wget https://launchpad.net/libmemcached/1.0/1.0.17/+download/libmemcached-1.0.17.tar.gz
	[root@xifan-nosql libmemcached-1.0.17]# tar zxvf libmemcached-1.0.17.tar.gz  ; cd libmemcached-1.0.17
	[root@xifan-nosql libmemcached-1.0.17]# ./configure --prefix=/usr/local/webserver/libmemcached && make && make install
	[root@xifan-nosql libmemcached-1.0.17]# /usr/local/bin/memslap --servers=127.0.0.1:21211  -T 8 -c 128   --cfg_cmd=/usr/local/bin/config --execute_number=100000


------
#注意:
------
	