Repcached(Memcached)编译测试
============================

概述:
------
1. Memcached Repcached 是memcached1.2.x的补丁.
2. 目的是实现memcached的数据复制属性，来实现memcached的数据备份。
3. 该补丁可以使memcached通过异步数据复制实现memcached的双向数据复制/备份功能.
4. 同时支持Memcached的所有操作指令.

环境：
------
	Centos 6.4 x86 (openvz)
	libevent-devel
	memcached-1.2.8-repcached-2.2.1.tar.gz

依赖：
------
	checking whether gcc and cc understand -c and -o together... yes
	checking for a BSD-compatible install... /usr/bin/install -c
	checking for libevent directory... configure: error: libevent is required.  You 
	can get it from http://www.monkey.org/~provos/libevent/

      If it's already installed, specify its path using --with-libevent=/dir/
    
依赖安装：

	[root@xifan-nosql ~]# yum install -y libevent-devel
	

编译安装Repcached(Memcached)：	
------------------

	[root@xifan-nosql ~]#  mkdir /home/zxl/packages -p
	[root@xifan-nosql ~]#  cd /home/zxl/packages
	[root@xifan-nosql zxl]# wget http://jaist.dl.sourceforge.net/project/repcached/repcached/2.2.1-1.2.8/memcached-1.2.8-repcached-2.2.1.tar.gz
	[root@xifan-nosql packages]# cd memcached-1.2.8-repcached-2.2.1
	[root@xifan-nosql memcached-1.2.8-repcached-2.2.1]# ./configure --enable-64bit --enable-replication --prefix=/usr/local/webserver/memcached --program-transform-name=s/memcached/repcached/
	[root@xifan-nosql memcached-1.2.8-repcached-2.2.1]# make && make install
	[root@xifan-nosql packages]# cd memcached-1.2.8-repcached-2.2.1
	[root@xifan-nosql memcached-1.2.8-repcached-2.2.1]# cd /usr/local/webserver/memcached/bin/
	[root@xifan-nosql bin]# ll
	total 392
	-rwxr-xr-x 1 root root 194036 Oct  5 23:44 repcached
	-rwxr-xr-x 1 root root 204645 Oct  5 23:44 repcached-debug
	[root@xifan-nosql bin]# ./repcached -h
	memcached 1.2.8
	repcached 2.2.1
	-p <num>      TCP port number to listen on (default: 11211)
	-U <num>      UDP port number to listen on (default: 11211, 0 is off)
	-s <file>     unix socket path to listen on (disables network support)
	-a <mask>     access mask for unix socket, in octal (default 0700)
	-l <ip_addr>  interface to listen on, default is INDRR_ANY
	-d            run as a daemon
	-r            maximize core file limit
	-u <username> assume identity of <username> (only when run as root)
	-m <num>      max memory to use for items in megabytes, default is 64 MB
	-M            return error on memory exhausted (rather than removing items)
	-c <num>      max simultaneous connections, default is 1024
	-k            lock down all paged memory.  Note that there is a
	              limit on how much memory you may lock.  Trying to
	              allocate more than that would fail, so be sure you
	              set the limit correctly for the user you started
	              the daemon with (not for -u <username> user;
	              under sh this is done with 'ulimit -S -l NUM_KB').
	-v            verbose (print errors/warnings while in event loop)
	-vv           very verbose (also print client commands/reponses)
	-h            print this help and exit
	-i            print memcached and libevent license
	-P <file>     save PID in <file>, only used with -d option
	-f <factor>   chunk size growth factor, default 1.25
	-n <bytes>    minimum space allocated for key+value+flags, default 48
	-R            Maximum number of requests per event
	              limits the number of requests process for a given con nection
	              to prevent starvation.  default 20
	-b            Set the backlog queue limit (default 1024)
	-x <ip_addr>  hostname or IP address of peer repcached
	-X <num:num>  TCP port number for replication. <listen:connect> (default: 11212)


启动Repcached(Memcached)：
--------------

	#默认复制监听端口:11212
	#Master Port:11211 

	[root@xifan-nosql bin]# ./repcached -v -l 127.0.0.1 -p 11211 -uroot -x 127.0.0.1 -X 11212
	replication: listen
	replication: accept (Slave 连接成功后提示)
	replication: connect (peer=127.0.0.1:11212)
	replication: marugoto copying
	replication: start
	replication: close
	replication: listen
	replication: accept
	replication: marugoto start
	replication: marugoto 4
	replication: marugoto owari

	#Slave Port:11213
	[root@xifan-nosql bin]# ./repcached -v -l 127.0.0.1 -p 11213 -uroot -x 127.0.0.1 -X 11212
	replication: connect (peer=127.0.0.1:11212)
	replication: marugoto copying
	replication: start
	replication: close
	replication: listen
	replication: accept
	replication: marugoto start
	replication: marugoto 4
	replication: marugoto owari

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
	* Repcached稳定性、大数据写入并发性、Repcliation数据一直性等场景还需要跟进。
