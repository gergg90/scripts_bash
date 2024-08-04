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
    echo -e "\t${purpleColor}m)${endColor}${grayColor} Buscador de maquinas ${endColor}"
    echo -e "\t${purpleColor}i)${endColor}${grayColor} Buscar por direccion IP${endColor}"
    echo -e "\t${purpleColor}l)${endColor}${grayColor} Buscar por maquina: para obtener link de youtube${endColor}"
    echo -e "\t${purpleColor}o)${endColor}${grayColor} Buscar maquina por sistema operativo SO${endColor}"
    echo -e "\t${purpleColor}s)${endColor}${grayColor} Buscar maquina por Skills${endColor}"
    echo -e "\t${purpleColor}d)${endColor}${grayColor} Buscar por dificultad:${endColor}\n\t${redColor}opciones ->${endColor} ${grayColor}[ Fácil, Media, Difícil, Insane ]${endColor}"
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
        curl -s $main_url | js-beautify >bundle_temp.js
        md5_temp_value="$(md5sum bundle_temp.js | awk '{print $1}')"
        md5_original_value="$(md5sum bundle.js | awk '{print $1}')"

        if [ "$md5_temp_value" != "$md5_original_value" ]; then
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Hay actualizaciones${endColor}"
            rm bundle.js
            mv bundle_temp.js bundle.js
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Archivos actualizados${endColor}"
        else
            echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}No hay actualizaciones pendientes${endColor}\n"
            rm bundle_temp.js
        fi

        tput cnorm
    fi
}

function searchMachine() {
    machineName="$1"
    infoMachine="$(cat bundle.js | grep "name: \"$machineName\"" -i -A 9 | grep -vE 'id:|sku:|resuelta:' | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/^/ /')"
    if [ "$infoMachine" ]; then
        echo -e "\n${yellowColor} [+]${endColor}${grayColor} Listando las propiedades de la maquina${endColor} ${blueColor}$machineName${endColor}"
        echo -e "${grayColor}$infoMachine${endColor}\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}Maquina no encontrada.${endColor}\n"
    fi

}

function searchIP() {
    ipAddress="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '",')"
    if [ "$machineName" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}IP:${endColor}${blueColor} $ipAddress${endColor}${grayColor} corresponde a la maquina ${endColor} ${redColor}$machineName\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}El IP:${endColor} ${blueColor}$ipAddress${endColor} ${redColor}no corresponde a ninguna maquina.${endColor}\n"
    fi
}

function getLinkYoutube() {
    machineNameLink="$1"
    linkYoutube="$(cat bundle.js | grep "name: \"$machineNameLink\"" -A 10 -i | grep "youtube: " | tr -d '",' | awk 'NF{print $NF}')"
    if [ "$linkYoutube" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Obteniendo el link de youtube de la maquina:${endColor} ${blueColor}$machineNameLink${endColor}"
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Link de youtube:${endColor} ${redColor}$linkYoutube${endColor}\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}La maquina proporcionada no existe${endColor}\n"
    fi
}

function searchByDifficulty() {
    difficultyLevel="$1"
    machinesLevel="$(cat bundle.js | grep "dificultad: \"$difficultyLevel\"" -B 5 -i | grep name | sed "s/^ *//" | tr -d '",' | awk 'NF{print $NF}' | column)"
    if [ "$machinesLevel" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Listando maquinas de nivel${endColor} ${redColor}$difficultyLevel${endColor}${grayColor}:${endColor}"
        echo -e "${grayColor}$machinesLevel${endColor}\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}No existe el nivel proporcionado ${endColor}\n"
    fi
}

function searchSO() {
    so="$1"
    resultSO="$(cat bundle.js | grep "so: \"$so\"" -B 6 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"
    if [ "$resultSO" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Listando maquinas con SO${endColor} ${redColor}$so${endColor}${grayColor}:${endColor}"
        echo -e "${grayColor}$resultSO${endColor}\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}No existe ninguna maquina con el sistema operativo: ${blueColor}$so${endColor} ${endColor}\n"
    fi
}

function searchDifficultySo() {

    result_df_SO="$(cat bundle.js | grep "so: \"$so\"" -C 5 -i | grep "dificultad: \"$difficultyLevel\"" -B 5 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"
    if [ "$result_df_SO" ]; then
        echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Listando maquinas con SO${endColor} ${redColor}$so${endColor}${grayColor} y de dificultad${endColor} ${redColor}$difficultyLevel${endColor}${grayColor}:${endColor}"
        echo -e "${grayColor}$result_df_SO${endColor}\n"
    else
        echo -e "\n${yellowColor} [x] ${endColor}${redColor}No existe ninguna maquina con estas caracteristicas ${endColor}\n"
    fi
}

function searchBySkills(){
  skills="$1"
  resultSkills="$(cat bundle.js | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"
  if [ "$resultSkills" ]; then
    echo -e "\n ${yellowColor}[+]${endColor} ${grayColor}Listando maquinas por Skills${endColor} ${redColor}$skills${endColor}${grayColor}:${endColor}"
    echo -e "${grayColor}$resultSkills${endColor}\n"
  else
    echo -e "\n${yellowColor} [x] ${endColor}${redColor}No existe ninguna maquina con estos skills: ${blueColor}$skills${endColor} ${endColor}\n"
  fi
}


# indicadores
declare -i parameter_counter=0
declare -i difficulty_chivato=0
declare -i so_chivato=0

# argumentos
while getopts "m:i:l:d:o:s:uh" arg; do
    case $arg in
    m)
        machineName="$OPTARG"
        let parameter_counter+=1
        ;;
    u)
        let parameter_counter+=2
        ;;
    i)
        ipAddress="$OPTARG"
        let parameter_counter+=3
        ;;
    l)
        machineNameLink="$OPTARG"
        let parameter_counter+=4
        ;;
    d)
        difficultyLevel="$OPTARG"
        let parameter_counter+=5
        let difficulty_chivato=1
        ;;
    o)
        so="$OPTARG"
        let parameter_counter+=6
        let so_chivato=1
        ;;
    s)
        skills="$OPTARG"
        let parameter_counter+=7
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
elif [ $parameter_counter -eq 4 ]; then
    getLinkYoutube $machineNameLink
elif [ $parameter_counter -eq 5 ]; then
    searchByDifficulty $difficultyLevel
elif [ $parameter_counter -eq 6 ]; then
    searchSO $so
elif [ $difficulty_chivato -eq 1 ] && [ $so_chivato -eq 1 ]; then
    searchDifficultySo $difficulyLevel $so
elif [ $parameter_counter -eq 7 ]; then
    searchBySkills "$skills"
else
    helpPanel
fi
