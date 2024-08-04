#!/bin/bash

function ctrl_c(){
    echo -e "\n [-] Saliendo..."
    exit 1
}

trap ctrl_c INT

function helpPanel(){
    echo -e "\n\n [!] Listando panel de ayuda\n"
}


while getopts "m:t:h" arg; do
  case $arg in
    m) 
        money=$OPTARG
      ;;
    t) 
        technique=$OPTARG
      ;;
    h)
      helpPanel
      ;;
    esac
done

if [ $money ] && [ $technique ]; then
    echo "Jugando con money $money"
else
  helpPanel
fi
