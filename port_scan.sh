#!/bin/bash

#Ctrl+C
function ctrl_c(){
    echo e- "\n [+]saliendo... \n"
    tput cnorm;
    exit 1
}

trap ctrl_c INT

tput civis 
for port in $(seq 1 65535); do
    (echo "" > /dev/tcp/127.0.0.1/$port ) 2> /dev/null && echo "Port: $port enabled" &
done; wait
tput cnorm