#! /bin/bash

# variables_blobales
main_url="https://htbmachines.github.io/bundle.js"

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquesaColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

function ctrl_c() {
    echo -e "\n\n ${redColor}[+]Saliendoo...${endColor}"
    tput cnorm && exit 1
}
# Ctrl_c >> cancelador
trap ctrl_c INT

# funciones
function helpPanel() {
    echo -e "\n${yellowColor}[+]${endColor}${grayColor}Uso:${endColor}"
    echo -e "\t${purpleColor}u)${endColor}${grayColor} Actualiza o descarga el archivo${endColor}"
    echo -e "\t${purpleColor}i)${endColor}${grayColor} Buscar por direccion IP${endColor}"$
    echo -e "\t${purpleColor}m)${endColor}${grayColor} Buscador de maquinas ${endColor}"
    echo -e "\t${purpleColor}h)${endColor}${grayColor} Mostrar panel de ayuda${endColor}\n"
}

function updateFiles() {
    if [ ! -f bundle.js ]; then
        tput civis
        echo -e "\n ${turquesaColor}[+]${endColor}${blueColor} Descargando archivos${endColor}"
        curl -s $main_url | js-beautify >bundle.js
        echo -e "\n ${turquesaColor}[+]${endColor}${blueColor} Archivos descargados exitosamente${endColor}\n"
        tput cnorm
    else
        tput civis
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Comprobando si hay actualizaciones pendientes...${endColor}"
        sleep 2
        curl -s $main_url | js-beautify >bundle_temp.js
        md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
        md5_original_value=$(md5sum bundle.js | awk '{print $1}')

        if [ "$md5_temp_value" != "$md5_original_value" ]; then
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Hay actualizaciones${endColor}"
            rm bundle.js
            mv bundle_temp.js bundle.js
            sleep 3
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Archivos actualizados${endColor}"
        else
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}No hay actualizaciones pendientes${endColor}"
            rm bundle_temp.js
        fi

        tput cnorm
    fi
}

function searchMachine() {
    machineName=$1
    echo -e "\n${yellowColor} [+]${endColor}${grayColor} Listando las propiedades de la maquina${endColor} ${blueColor}$machineName${endColor}\n"
    cat bundle.js | awk "/name: \"$machineName\"/, /resuelta:/" | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
}

function searchIP() {
    ipAddress=$1
    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '",')"
    echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}La maquina correspondiente al ip:${endColor}${blueColor} $ipAddress${endColor}${grayColor}, es:${endColor} ${redColor}$machineName${endColor}\n"

}

# indicadores
declare -i parameter_counter=0

# argumentos
while getopts "m:i:uh" arg; do
    case $arg in
    m)
        machineName=$OPTARG
        let parameter_counter+=1
        ;;
    i)
        ipAddress=$OPTARG
        let parameter_counter+=3
        ;;
    u)
        let parameter_counter+=2
        ;;
    h) ;;
    esac
done

# controladores de argumentos
if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
    updateFiles
elif [ $parameter_counter -eq 3 ]; then
    searchIP $ipAddress
else
    helpPanel
fi
