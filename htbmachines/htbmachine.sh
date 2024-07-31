#! /bin/bash

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

function ctrl_c() {
    echo -e "\n\n ${redColor}[+]Saliendoo...${endColor}"
    exit 1
}
# Ctrl_c
trap ctrl_c INT

function helpPanel() {
    echo -e "\n${yellowColor}[+]${endColor}${grayColor}Uso:${endColor}"
    echo -e "\t${purpleColor}u)${endColor}${grayColor} Update or download files${endColor}"
    echo -e "\t${purpleColor}m)${endColor}${grayColor} Search a machine name${endColor}"
    echo -e "\t${purpleColor}h)${endColor} ${grayColor}Show help panel${endColor}\n"

}

function searchMachine() {
    echo -e "\n ${purpleColor}[+] Esta es la maquina: $1${endColor}"
}

function updateFiles() {
    echo -e "\n [+] Update Files"
}

# Indicadores
declare -i parameter_counter=0

while getopts "m:uh" arg; do
    case $arg in
    m)
        machineName=$OPTARG
        let parameter_counter+=1
        ;;
    u)
        let parameter_counter+=2
        ;;
    h) ;;
    esac
done

if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
    updateFiles
else
    helpPanel
fi
