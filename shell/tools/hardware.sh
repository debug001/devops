#!/bin/bash
netcard=`lspci |grep -i ethernet |wc -l`
speed=`for ((i=0; i<$netcard; i++));do ethtool eth$i|grep Speed ;done |awk -F ":" ' {++S[$2]} END {for(a in S) print a, S[a]}'`
netmacaddress=`for ((i=0; i<$netcard; i++));do echo eth$i; cat /sys/class/net/eth$i/address ;done`
release_date=`dmidecode  | grep "Release Date"`
cpusum=`cat /proc/cpuinfo | grep "physical id" | sort |uniq| wc -l`
cpulogicnum=`cat /proc/cpuinfo | grep processor | wc -l`
cpuversion=`grep 'model name' /proc/cpuinfo |awk -F: '{print $2}' |uniq`
memsum=`dmidecode -t memory | grep Size |grep MB|wc -l`
memsize_M=`dmidecode -t memory | grep Size |grep MB|uniq |awk '{print $2}'`
memsize=`expr $memsize_M / 1024`
diskinfo=`fdisk -l|grep Disk| cut -d ',' -f1`
echo CPU Info :$cpuversion \* $cpusum 
echo CPU Logic Num : $cpulogicnum
echo MEM : ${memsize}GB \* $memsum
echo Disk : ${diskinfo}
echo NetCard : $netcard port 
echo NetCard Speed : ${speed} 
echo NetCard L2 address : ${netmacaddress}
echo Release Date : $release_date
