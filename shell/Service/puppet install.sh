puppet install 

rpm -ivh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum makecache

#slave
yum install -y puppet git

# master
yum install -y puppet-server git

#slave and master
echo "
192.168.1.145   kq-web-145.jh.hupu.com
192.168.8.124   pub-pupet-1-120.jh.hupu.com
" >> /etc/hosts

#slave 
echo "
[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = $vardir/ssl
    server = pub-pupet-1-120.jh.hupu.com 
    runinterval = 3600
[agent]
    classfile = $vardir/classes.txt
    localconfig = $vardir/localconfig
    listen = true
    bindaddress = 192.168.8.145

" 	> /etc/puppet/puppet.conf

echo "
path ~ ^/catalog/([^/]+)$
method find
allow $1
path /certificate_revocation_list/ca
method find
allow *
path ~ ^/report/([^/]+)$
method save
allow $1
path /file
allow *
path /certificate/ca
auth no
method find
allow *
path /certificate/
auth no
method find
allow *
path /certificate_request
auth no
method find, save
allow *
path /run
method save
allow pub-pupet-1-120.jh.hupu.com
path /
auth any
" > /etc/puppet/auth.conf 

#master 
echo "
[base]
    path /etc/puppet/modules/base/files
    allow *.hupu.com
    allow *.jh

[httpd]
    path /etc/puppet/modules/httpd/files
    allow *.hupu.com

[sshd]
    path /etc/puppet/modules/sshd/files
    allow *.hupu.com

[nginx]
    path /etc/puppet/modules/nginx/files
    allow *.hupu.com
" > /etc/puppet/fileserver.conf 


#service restart
#slave 
/etc/init.d/puppet restart
#master
/etc/init.d/puppetmaster restart


#认证
#slave
puppet agent --test --server puppet-master.jh.hupu.com
#master
puppetca -all
puppetca -s puppet-slave.jh.hupu.com

认证完成。

#推送配置
puppet kick -d --host puppet-slave.jh.hupu.com
#拉取配置
puppet agent --test --server puppet-master.jh.hupu.com


#基本搭建完成。