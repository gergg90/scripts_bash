#!/bin/bash

#Colors$
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquesaColor="\e[0;36m\033[1m"
greyColor="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n [-] Saliendo..."
    exit 1
}

trap ctrl_c INT

function helpPanel(){
  echo -e "\n${turquesaColor}[!]${endColor} ${greyColor}Uso:${endColor}"
  echo -e "\t${turquesaColor}(-m)${endColor} ${greyColor}ingrese la cantidad de su dinero${endColor}"
  echo -e "\t${turquesaColor}(-t)${endColor} ${greyColor}ingrese la tecnica de juego:${endColor} ${turquesaColor}(${endColor}${yellowColor}martingala${endColor}${turquesaColor}/${endColor}${yellowColor}inverseLabrouchere${endColor}${turquesaColor})${endColor}"
  echo -e ""
}

function martingala(){
  technique="$1"  
  echo "Hola desde fun $technique"
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
    if [ $technique == "martingala" ]; then
      martingala $technique
    else
      echo -e "\n ${redColor}[x] La tecnica introducida no existe${endColor}"
      helpPanel
    fi
else
  helpPanel
fi
