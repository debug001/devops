#!/bin/sh
#Centos5.x_x64 + Nginx 1.2.6 + php 5.3.21 + mariadb 5.5.29 installer
#如果需要用到pdo请用源码编译mysql，并修改此文件中相应的行
#此安装包适合在X_64下安装,X_32需要做相应的修改
#注意此脚本建议加上 x 权限以./lnmpinstall_x64.sh运行，不建议用sh lnmpinstall_x64.sh运行
#Copyright HC 2010-2015
#Last modify date 2010-12-02
#2010-06-21 modify ZendOptimizer

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@@  Plase wait  ......  @@@@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

/bin/ping -c 3 -w 3 www.baidu.com > /dev/null
if [[ $? -eq 0 ]];then

echo "###########################################"
echo "## LNMP Start Installer. Plaste wait.... ##"
echo "###########################################"

# wget http://down1.chinaunix.net/distfiles/libiconv-1.13.1.tar.gz
# wget http://blog.s135.com/soft/linux/nginx_php/mcrypt/libmcrypt-2.5.8.tar.gz
# wget http://blog.s135.com/soft/linux/nginx_php/mcrypt/mcrypt-2.6.8.tar.gz
# wget http://ncu.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.bz2
# wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.01.tar.bz2
# wget http://qdbm.sourceforge.net/qdbm-1.8.77.tar.gz
# wget http://php-fpm.org/downloads/php-5.2.17-fpm-0.5.14.diff.gz
# wget http://cn.php.net/distributions/php-5.2.17.tar.bz2
# wget http://pecl.php.net/get/memcache-2.2.5.tgz
# wget https://launchpad.net/libmemcached/1.0/1.0.4/+download/libmemcached-1.0.4.tar.gz
# wget http://downloads.zend.com/optimizer/3.3.9/ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
# wget http://www.nginx.org/download/nginx-1.0.12.tar.gz
# wget http://monkey.org/~provos/libevent-2.0.17-stable.tar.gz
# wget http://memcached.googlecode.com/files/memcached-1.4.13.tar.gz
# wget http://mysql.mirror.tw/Downloads/MySQL-5.1/mysql-5.1.56.tar.gz
# wget http://bart.eaccelerator.net/source/0.9.6.1/eaccelerator-0.9.6.1.tar.bz2

#/usr/sbin/groupadd www
#/usr/sbin/useradd -g www www
#/bin/mkdir -p /usr/local/webserver
#/bin/mkdir -p /data0/nginx/logs
#/bin/mkdir -p /data0/phplogs
#/bin/chown -R www:www /data0

### yum 安装mysql.数据库不在本地,本地数据库只是用来连接远程数据库(不支持pdo等应用)
#yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers openldap-devel db4 db4-devel db-utils sysstat lrzsz vim* mysql mysql-devel mysql-server libtool libtool-ltdl-devel patch make libtool libxml2 libxml2-devel openssl* curl curl-devel gd gd-devel ImageMagick ImageMagick-devel

### tar包安装执行此yum(支持pdo，其它应用可以编译相应选项)
#yum -y install cmake ncurses-devel libaio-devel gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers openldap-devel sysstat lrzsz db4 db4-devel db4-utils vim* libtool libtool-ltdl-devel patch make libtool libxml2 libxml2-devel openssl* curl curl-devel gd gd-devel ImageMagick ImageMagick-devel 

###############################
### installer update packet ###
###############################
#yum -y update

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### 查找NginxSoftware.tar.bz2文件是否存在
FIND_NS_DIR=`find / -name NginxSoftware.tar.bz2 | rev | cut -b 23- | rev`
cd $FIND_NS_DIR
if [ `/bin/pwd` != $FIND_NS_DIR ];then
	echo "NginxSoftware.tar.bz2 file not exist. plase confirm file if ture exist."
	exit 1
fi
### 解压NginxSoftware.tar.bz2文件
CUR=`pwd`
NS_DIR=${CUR}/NginxSoftware
/bin/rm -rf $NS_DIR
tar xf NginxSoftware.tar.bz2
cd $NS_DIR

tar zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr
make
make install&&echo "OK"||exit 
cd $NS_DIR

tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr
make
make install&&echo "OK"||exit 
cd libltdl
./configure --enable-ltdl-install
make
make install&&echo "OK"||exit 
ln -s /usr/local/bin/libmcrypt-config /usr/bin/
cd $NS_DIR

# start install mhash
tar jxvf mhash-0.9.9.9.tar.bz2
cd mhash-0.9.9.9
./configure --prefix=/usr
make
make install&&echo "OK"||exit 
cd $NS_DIR

tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8
/sbin/ldconfig
./configure
make
make install&&echo "OK"||exit 
cd $NS_DIR

# start installer qdbm
tar zxvf qdbm-1.8.77.tar.gz
cd qdbm-1.8.77
./configure --prefix=/usr
make
make install&&echo "OK"||exit 
cd $NS_DIR

ln -s /usr/lib/lib.so /usr/lib64/
ln -s /usr/lib/libmhash.* /usr/lib64/
ln -s /usr/lib/libiconv.* /usr/lib64/
ln -s /usr/lib/libqdbm.* /usr/lib64/
ldconfig

############################
### start installer mysql ##
############################
echo "###################################"
echo "### MariaDB 5.5.29 Start Install. ###"
echo "###################################"
## 源码安装MYSQL,请将下面的注释取消
/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql
###配置编译器提高性能
CFLAGS="-O3"
CXX=gcc
CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti"

tar -zxvf mariadb-5.5.29.tar.gz
cd mariadb-5.5.29
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/webserver/mysql -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1  -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci   -DWITH_DEBUG=0 -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community -DWITH_EMBEDDED_SERVER=OFF
make
make install&&echo "OK"||exit 0
chmod +w /usr/local/webserver/mysql
chown -R mysql:mysql /usr/local/webserver/mysql
#################如果要在这台服务器上面运行mysql数据库执行下面两步#################
#创建mysql数据库存放目录
mkdir -p /data0/mysql/3306/data/
mkdir -p /data0/mysql/3306/binlog/
mkdir -p /data0/mysql/3306/relaylog/
chown -R mysql:mysql /data0/mysql/
#以mysql用户帐号的身份建立数据表
/usr/local/webserver/mysql/bin/mysql_install_db --basedir=/usr/local/webserver/mysql --datadir=/data0/mysql/3306/data --user=mysql


mkdir /usr/local/webserver/mysql/var
cp support-files/my-innodb-heavy-4G.cnf  /etc/my.cnf
sed -i 's#skip-federated#\#skip-federated#' /etc/my.cnf
sed -i 's#@MYSQL_TCP_PORT@#3306#g' /etc/my.cnf
sed -i 's#@MYSQL_UNIX_ADDR@#\/tmp\/mysql.sock#g' /etc/my.cnf
#sed -i 's#@MYSQL_UNIX_ADDR@#\/usr\/local\/webserver\/mysql\/var\/mysql.sock#g' /etc/my.cnf
ln -s /usr/local/webserver/mysql/lib /usr/local/webserver/mysql/lib64
/usr/local/webserver/mysql/bin/mysql_install_db --basedir=/usr/local/webserver/mysql --datadir=/usr/local/webserver/mysql/var --user=mysql
echo '#/usr/local/webserver/mysql/bin/mysqld_safe --user=mysql &' >> /etc/rc.local
cd $NS_DIR
echo "###############################"
echo "### MYSQL Install souccess. ###"
echo "###############################"

ln -s /usr/local/webserver/mysql/lib/libmysqlclient.so.18 /usr/lib64
ln -s /usr/local/webserver/mysql/lib/libmysqlclient.so.18 /usr/lib
###########################
### start installer php ###
###########################
echo "#################################"
echo "### php-5.3.21 Start Install. ###"
echo "#################################"
tar jxvf php-5.3.21.tar.bz2
cd php-5.3.21
###################################################################################################
## ./configure时如果出以下错误
## 	checking for mysql_config... not found
## 	configure: error: Cannot find MySQL header files under 
## 1. 如果是rpm安装mysql需要安装mysql-devel,find /usr -name mysql.h是否存在,没有安装mysql-devel包mysql.h是不存在的
## 2. 如果是源码编译安装，执行此命令 ln -s /usr/local/mysql/bin/mysql_config /usr/bin/mysql_config 然后修改./cofnigure --with-mysqli参数为 --with-mysqli=/usr/bin/mysql_config
## (注：以上是在32位系统上编译php报错的解决办法)
###################################################################################################
mkdir /usr/lib64/mysql
export LDFLAGS=-L/usr/lib64/mysql
### 注：64位系统需要此参数，32位无需设置。否则编译时会出现以下错误：
## configure: error: mysql configure failed. Please check config.log for more information. ###
./configure --prefix=/usr/local/webserver/php --with-config-file-path=/usr/local/webserver/php/etc --with-mysql=/usr/local/webserver/mysql --with-mysqli=/usr/local/webserver/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath  --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex  --enable-fpm  --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap



make ZEND_EXTRA_LIBS='-liconv'&&echo "OK"||exit
#make test
make install&&echo "OK"||exit 0
cp php.ini-dist /usr/local/webserver/php/etc/php.ini
ln -s /usr/local/webserver/php/bin/php /usr/local/bin/
cd $NS_DIR
echo "#############################"
echo "### PHP Install souccess. ###"
echo "#############################"

## start installer php-memcached
tar zxvf memcache-2.2.5.tgz
cd memcache-2.2.5
/usr/local/webserver/php/bin/phpize
./configure --enable-eaccelerator=shared --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install&&echo "OK"||exit 0
cd $NS_DIR

## start installer php-eaccelerator 
tar jxvf eaccelerator-0.9.6.1.tar.bz2
cd eaccelerator-0.9.6.1
/usr/local/webserver/php/bin/phpize
./configure --enable-eaccelerator --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install&&echo "OK"||exit 0
cd $NS_DIR

## start installer php-redis module
tar zxvf owlient-phpredis-2.1.1-1-g90ecd17.tar.gz
cd owlient-phpredis-90ecd17
/usr/local/webserver/php/bin/phpize
./configure --enable-redis --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install&&echo "OK"||exit 0
cd $NS_DIR

## start installer php-imagick module
tar zxvf imagick-3.1.0b1.tgz
cd imagick-3.1.0b1
/usr/local/webserver/php/bin/phpize
./configure --with-imagick --with-php-config=/usr/local/webserver/php/bin/php-config 
make
make install&&echo "OK"||exit 0
cd $NS_DIR

## start installer hupu badwords module
tar zxvf HoopCHINA-badwords-d28a077.tar.gz 
cd HoopCHINA-badwords-d28a077
/usr/local/webserver/php/bin/phpize
./configure --enable-badwords --with-php-config=/usr/local/webserver/php/bin/php-config 
make
make install&&echo "OK"||exit 0
cd $NS_DIR


##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# start installer php-plugin
sed -i 's#extension_dir = "./"#extension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20090626/"\nextension = "memcached.so"\nextension = "redis.so"\nextension = "imagick.so"\nextension = "memcache.so"\nextension = "pdo.so"\nextension = "sqlite.so"\nextension = "pdo_sqlite.so"\nextension = "pdo_mysql.so"\nextension = "apc.so"\n;extension = "xhprof.so"\n;extension = "ZendOptimizer.so"\nextension = "badwords.so"\n#' /usr/local/webserver/php/etc/php.ini
sed -i 's#output_buffering = Off#output_buffering = On#' /usr/local/webserver/php/etc/php.ini
sed -i 's#expose_php = On#expose_php = Off#' /usr/local/webserver/php/etc/php.ini
sed -i 's#display_errors = On#display_errors = Off#' /usr/local/webserver/php/etc/php.ini
sed -i 's#\;error_log = filename#error_log = /usr/local/webserver/php/logs/error.log#' /usr/local/webserver/php/etc/php.ini
sed -i 's#log_errors = Off#log_errors = On#' /usr/local/webserver/php/etc/php.ini
sed -i 's#allow_url_include = Off#allow_url_include = On#' /usr/local/webserver/php/etc/php.ini
sed -i 's#mysql.default_port =#mysql.default_port = 3306#' /usr/local/webserver/php/etc/php.ini
sed -i 's#mysql.allow_persistent = On#mysql.allow_persistent = Off#' /usr/local/webserver/php/etc/php.ini
sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 6M#' /usr/local/webserver/php/etc/php.ini
sed -i 's#\;include_path = \"\.\:/php/includes"#include_path = \"\.\:/usr/local/smarty:/usr/local/PEAR;/home/www/gh\"#' /usr/local/webserver/php/etc/php.ini

touch /usr/local/webserver/php/logs/error.log
chmod 666 /usr/local/webserver/php/logs/error.log
mkdir -p /usr/local/webserver/eaccelerator_cache

cat >> /usr/local/webserver/php/etc/php.ini << eof

[eaccelerator]
zend_extension="/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20090626/eaccelerator.so"
eaccelerator.shm_size="128"
eaccelerator.cache_dir="/usr/local/webserver/eaccelerator_cache"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="300"
eaccelerator.shm_prune_period="120"
eaccelerator.shm_only="0"
eaccelerator.compress="0"
eaccelerator.compress_level="9"

eof

tail -n 20 /usr/local/webserver/php/etc/php.ini


##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

tar xf ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz
cp ZendOptimizer-3.3.9-linux-glibc23-x86_64/data/5_2_x_comp/ZendOptimizer.so /usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20090626/
##(此处extension配置已经在上面的命仅中加入php.ini)

cat >> /usr/local/webserver/php/etc/php.ini << eof
[ZendOptimizer]
zend_extension = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20090626/ZendOptimizer.so"
zend_optimizer.optimization_level = "1023"
zend_optimizer.encoder_loader = "0"

eof

tail /usr/local/webserver/php/etc/php.ini
ln -s /usr/local/webserver/php/sbin/php-fpm  /usr/local/bin
mv /usr/local/webserver/php/etc/php-fpm.conf /usr/local/webserver/php/etc/php-fpm.conf.default
cp php-fpm.conf  /usr/local/webserver/php/etc/

# install xhprof php_mod
tar zxvf xhprof-0.9.2.tgz
cd xhprof-0.9.2/extension
/usr/local/webserver/php/bin/phpize
./configure --enable-xhprof --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install&&echo "OK"||exit 0
cd $NS_DIR

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# start installer Ngnix
## start installer pcre plugin.
tar jxvf pcre-8.13.tar.bz2
cd pcre-8.13
./configure --enable-utf8 --enable-pcregrep-libz --enable-pcregrep-libbz2
make
make install&&echo "OK"||exit 0
cd $NS_DIR

## google-perftools plugin installer.
tar zxvf libunwind-0.99-beta.tar.gz
cd libunwind-0.99-beta
./configure
make
make install&&echo "OK"||exit 0
cd $NS_DIR

tar zxvf google-perftools-1.8.3.tar.gz
cd google-perftools-1.8.3
./configure --enable-frame-pointers
make
make install&&echo "OK"||exit 0
cd $NS_DIR


## uncompressor nginx modules
tar zxvf nginx-static-etags_ok.tar.gz 
tar zxvf nginx_upload_module-2.2.0.tar.gz

echo "###################################"
echo "### Nginx 1.2.6 Start Install. ###"
echo "###################################"
tar zxvf nginx-1.2.6.tar.gz
cd nginx-1.2.6
sed -i 's#CFLAGS=\"\$CFLAGS -g\"#\#CFLAGS=\"\$CFLAGS -g\"#' auto/cc/gcc
sed -i 's#\#NGX_GCC_OPT="-O2"#NGX_GCC_OPT="-O2"#' auto/cc/gcc
sed -i 's#NGX_GCC_OPT="-O"#\#NGX_GCC_OPT="-O"#' auto/cc/gcc
#sed -i 's#Server\: nginx"#Server\: \[SA\: Life HUPU/WEB-SERVER \]\[AD\: http\:\/\/www\.hupu\.com \]\"#' src/http/ngx_http_header_filter_module.c
#sed -i 's#\"Server\: \" NGINX_VER#\"Server\: \[SA\: Life HUPU/WEB-SERVER \]\[AD\: http\:\/\/www\.hupu\.com \]\"#' src/http/ngx_http_header_filter_module.c
./configure --prefix=/usr/local/webserver/nginx \
--user=www  \
--group=www \
--with-md5=/usr/lib \
--with-sha1=/usr/lib \
--with-pcre \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_flv_module \
--with-google_perftools_module \
--with-cc-opt=' -O3' \
--with-cc=/usr/bin/gcc \
--add-module=${NS_DIR}/nginx-static-etags \
--add-module=${NS_DIR}/nginx_upload_module-2.2.0 \
--without-http_uwsgi_module \
--without-http_scgi_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module
make
make install&&echo "OK"||exit 0
ln -s /usr/local/webserver/nginx/sbin/nginx /usr/local/bin	###create soft link
ln -s /usr/local/lib/libprofiler.so.0 /usr/lib64/
cd $NS_DIR
echo "###############################"
echo "### Nginx Install souccess. ###"
echo "###############################"

## more develop paket
tar zxvf  smarty.tar.gz -C /usr/local/
tar zxvf  PEAR.tar.gz -C /usr/local/  
tar zxvf  monitor.tar.gz -C /home/		###start monitor scripts
#tar zxvf  conf.tar.gz -C /usr/local/webserver/nginx	###nginx config file

## start installer libevent
tar zxvf libevent-2.0.17-stable.tar.gz
cd libevent-2.0.17-stable
CFLAGS="-march=nocona -O2 -pipe"
CXXFLAGS="${CFLAGS}"
./configure --prefix=/usr/
make
make install&&echo "OK"||exit 0
ln -s /usr/lib/libevent-* /usr/lib64/
cd $NS_DIR

## start install memcached
tar zxvf memcached-1.4.13.tar.gz
cd memcached-1.4.13
CFLAGS="-march=nocona -O2 -pipe"
CXXFLAGS="${CFLAGS}"
./configure --prefix=/usr/local/memcached --with-libevent=/usr
make
make install&&echo "OK"||exit 0
ln -s /usr/local/memcached/bin/memcached /usr/local/bin/
cd $NS_DIR

## start install libmemcached
tar zxvf libmemcached-1.0.4.tar.gz
cd libmemcached-1.0.4
./configure --prefix=/usr/local/libmemcached --with-memcached=/usr/local/memcached/bin/memcached
make
make install&&echo "OK"||exit 0
cd /usr/local/libmemcached/lib
ln -s libmemcached.so.9.0.0 libmemcached.so.5
cd $NS_DIR

## start installl php-memcached module
gunzip -d memcached-1.0.2.tgz
tar xvf memcached-1.0.2.tar
cd memcached-1.0.2
/usr/local/webserver/php/bin/phpize 
./configure --enable-memcached --with-libmemcached-dir=/usr/local/libmemcached --with-php-config=/usr/local/webserver/php/bin/php-config 
make
make install&&echo "OK"||exit 0
cd $NS_DIR

mkdir /root/sshell
cat > /root/sshell/memcacherestart.sh << eof
#!/bin/bash
killall -9 memcached
/usr/local/memcached/bin/memcached -d -m 512 -u www -l 127.0.0.1 -p 11211 -U 0 -t 16 -R 80 -b 8192 -c 8192 -P /var/run/memcached.pid
cat /var/run/memcached.pid
eof

chmod +x /root/sshell/memcacherestart.sh
echo '/usr/local/webserver/nginx/sbin/nginx' >> /etc/rc.local
echo '/usr/local/webserver/php/sbin/php-fpm start' >> /etc/rc.local
echo '/root/sshell/memcacherestart.sh' >> /etc/rc.local
ln -s /usr/local/lib/libunwind.so.7 /usr/lib64/
######################################
### installer PHP APC acceleration ###
######################################
##wget http://pecl.php.net/get/APC
##tar zxvf APC
tar zxvf APC-3.1.9.tar.gz
cd APC-3.1.9
/usr/local/webserver/php/bin/phpize
./configure --prefix=/usr/local/webserver/apc --enable-apc --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install&&echo "OK"||exit 0
cd ../
##vi /usr/local/webserver/php/etc/php.ini
#查找/usr/local/webserver/php/etc/php.ini中的extension_dir = "./"
#修改为extension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20090626/"
#在其下加入以下内容:
##extension = "apc.so";
#按shift+g键跳到配置文件的最末尾，加上以下配置信息：
#引用
cat >> /usr/local/webserver/php/etc/php.ini << eof

[APC]
apc.enable = 1
apc.shm_size = 512M 
apc.cache_dir = /usr/local/webserver/apc
apc.optimizer = 5
apc.debug = 0
apc.shm_max = 0
apc.ttl = 3600 
apc.shm_ttl = 3600 
apc.user_ttl = 3600 
apc.shm_prune_period = 3600 
apc.shm_only = 0
apc.cache_by_default = on
apc.shm_segments = 1
apc.num_files_hint = 2048 
apc.user_entries_hint = 8192 
apc.stat = 1
apc.write_lock = 1
apc.slam_defense = 50
;apc.check_mtime = 1
;apc.stat_ctime = 0
;apc.filter = "+php$,inc$"
;apc.compress = 1
;apc.compress_level = 5

eof

echo "############################"
echo "## LNMP Install souccess. ##"
echo "############################"

else
	echo "could not access intenet network, not ping www.baidu.com domain.plase check network. "
fi

exit 0
