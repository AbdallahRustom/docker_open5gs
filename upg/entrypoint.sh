#!/bin/bash

ip link set $INTERFACE_ACCESS down
ip link set $INTERFACE_ACCESS name n3
ip link set n3 up

ip link set $INTERFACE_CP down
ip link set $INTERFACE_CP name n4
ip link set n4 up

ip link set $INTERFACE_CORE down
ip link set $INTERFACE_CORE name n6
ip link set n6 up

#ip route add $NETWORK_UE_IP via $SGI_IPV4 dev n6
vpp -c /mnt/upg/startup.conf
