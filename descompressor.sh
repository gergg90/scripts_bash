#!/bin/bash

function ctrl_c(){
    
    echo -e "\n\n [+]Saliendooooo! \n"
    exit 1
}
# Clrl+C

trap ctrl_c INT

file_name="data.gz"

while [ $file_name ]; do
    deco_file_name="$(7z l $file_name | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"
    echo -e "\n [+] Nuevo archivo descomprimido $deco_file_name"
    7z x $file_name &> /dev/null
    file_name=$deco_file_name
    
    
done

