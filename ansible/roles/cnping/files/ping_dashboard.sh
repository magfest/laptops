#!/usr/bin/env bash

def_route="$(ip route | grep default)"
dev="$(echo $def_route | cut -f5 -d' ')"
ip_addr="$(echo $def_route | cut -f3 -d' ')"
echo ${dev}
echo ${ip_addr}
TARGET="8.8.8.8"
TITLE="${dev} ${ip_addr} -> ${TARGET}"
cnping -p 0.5 ${TARGET} -t "${TITLE}"