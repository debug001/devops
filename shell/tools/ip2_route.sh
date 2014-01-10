#!/bin/bash
##
## CNC_RULE AND CTC_RULE from /etc/iproute2/rt_tables
## E.G # echo 200 cnc >> /etc/iproute2/rt_tables
##     # echo 201 ctc >> /etc/iproute2/rt_tables
##
CTC_DEVICE="eth1"
CTC_RULE="ctc"
CTC_NETWORK="122.226.59.240"
CTC_GATEWAY="122.226.59.161"
CTC_IPADDR="122.226.59.174"


CNC_DEVICE="eth2"
CNC_RULE="cnc"
CNC_NETWORK="60.12.147.0"
CNC_GATEWAY="60.12.147.1"
CNC_IPADDR="60.12.147.35"

ACTION="add"

if [ $# -ne 0 ]; then
        if [ "$1" != "add" -a "$1" != "del" ]; then
                echo "error"
        else
                ACTION="$1"
        fi
fi

ip route ${ACTION} ${CNC_NETWORK} dev ${CNC_DEVICE} src ${CNC_IPADDR} table ${CNC_RULE}
ip route ${ACTION} default via ${CNC_GATEWAY} table ${CNC_RULE}

ip route ${ACTION} ${CTC_NETWORK} dev ${CTC_DEVICE} src ${CTC_IPADDR} table ${CTC_RULE}
ip route ${ACTION} default via ${CTC_GATEWAY} table ${CTC_RULE}

ip rule ${ACTION} from ${CNC_IPADDR} table ${CNC_RULE}
ip rule ${ACTION} from ${CTC_IPADDR} table ${CTC_RULE}

ip route add default via ${CTC_GATEWAY}
