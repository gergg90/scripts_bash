#!/bin/bash

#Ctrl+C
function ctrl_c(){
    echo e- "\n [+]saliendo... \n"
    exit 1
}

trap ctrl_c INT

for port in $(seq 1 254); do
    timeout 1 bash -c "ping -c 1 192.168.0.$port &> /dev/null" && echo "Host: 192.168.0.$port open" &
done; wait
