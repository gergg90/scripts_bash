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

function ctrl_c() {
  echo -e "\n [-] Saliendo..."
  tput cnorm
  exit 1
}

trap ctrl_c INT

function helpPanel() {
  echo -e "\n${turquesaColor}[!]${endColor} ${greyColor}Uso:${endColor}"
  echo -e "\t${turquesaColor}(-m)${endColor} ${greyColor}ingrese la cantidad de su dinero${endColor}"
  echo -e "\t${turquesaColor}(-t)${endColor} ${greyColor}ingrese la tecnica de juego:${endColor} ${turquesaColor}(${endColor}${yellowColor}martingala${endColor}${turquesaColor}/${endColor}${yellowColor}inverseLabrouchere${endColor}${turquesaColor})${endColor}"
  echo -e ""
}

function martingala() {
  echo -e "\n${turquesaColor}[!]${endColor} ${greyColor}Cantidad de dinero actual${endColor} ${blueColor}$money${endColor}"
  echo -ne "${yellowColor}[+]${endColor} ${greyColor}Ingrese dinero a apostar:${endColor} " && read initial_bet
  echo -ne "${yellowColor}[+]${endColor} ${greyColor}Seleccione un si desea apostar a (par/impar):${endColor} " && read par_impar
  echo -e "${yellowColor}[!!]${endColor} ${greyColor}Se inicial el juego con la cantidad de${endColor} ${yellowColor}($initial_bet$)${endColor} ${greyColor}a los${endColor} ${yellowColor}(# $par_impar)${endColor}"

  tput civis
  while true; do
    random_number="$(($RANDOM % 37))"
    echo -e "\n${yellowColor}[+]${endColor} ${greyColor}Ha salido el numero${endColor} ${blueColor}$random_number${endColor}"
    if [ "$(($random_number % 2))" -eq 0 ]; then
      if [ $random_number -eq 0 ]; then
        echo -e "${redColor}[+] Perdida por ley${endColor}"
      else
        echo -e "${yellowColor}[+]${endColor} ${greyColor}Numero par${endColor}"
      fi
    else
      echo -e "${yellowColor}[+]${endColor} ${greyColor}Numero impar${endColor}"
    fi
    sleep 0.5
  done
  tput cnorm
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
    martingala
  else
    echo -e "\n ${redColor}[x] La tecnica introducida no existe${endColor}"
    helpPanel
  fi
else
  helpPanel
fi
