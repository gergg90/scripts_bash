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
	echo -e "\n${redColor}[-] Saliendo...${endColor}\n"
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
	echo -e "${yellowColor}[!]${endColor} ${greyColor}Se inicial el juego con la cantidad de${endColor} ${yellowColor}($initial_bet$)${endColor} ${greyColor}a los${endColor} ${yellowColor}(numeros # $par_impar)${endColor}"

	backup_initial_bet=$initial_bet
	play_counter=1
	bad_plays=""

	tput civis
	while true; do
		money=$((money - initial_bet))
		echo -e "\n${yellowColor}[+]${endColor} ${greyColor}Cantidad apostada${endColor}${yellowColor} -> $initial_bet$ ${endColor}${greyColor}, saldo restante${endColor}${yellowColor} -> $money$ ${endColor}"
		random_number="$((RANDOM % 37))"
		echo -e "${yellowColor}[+]${endColor} ${greyColor}Ha salido el numero${endColor} ${blueColor}$random_number${endColor}"

		if [ ! "$money" -lt 0 ]; then
			if [ "$par_impar" == "par" ]; then
				if [ "$((random_number % 2))" -eq 0 ]; then
					if [ $random_number -eq 0 ]; then
						echo -e "${yellowColor}[+]${endColor} ${redColor}Numero CERO. Jaja! ${endColor}"$
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"$
						initial_bet=$((initial_bet * 2))
					else
						echo -e "${yellowColor}[+]${endColor} ${greenColor}Numero par. GANASTE!! ${endColor}"
						reward=$((initial_bet * 2))
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Ganas un total de${endColor} ${yellowColor}$reward$ ${endColor}"
						money=$((money + reward))
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"
						initial_bet=$backup_initial_bet
						bad_plays=""
					fi
				else
					echo -e "${yellowColor}[+]${endColor} ${redColor}Numero impar. Perdiste!! ${endColor}"
					echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"
					initial_bet=$((initial_bet * 2))
					bad_plays+="$random_number "
				fi
			else
				if [ "$((random_number % 2))" -eq 1 ]; then
					if [ $random_number -eq 0 ]; then
						echo -e "${yellowColor}[+]${endColor} ${redColor}Numero CERO. Jaja! ${endColor}"$
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"$
						initial_bet=$((initial_bet * 2))
					else
						echo -e "${yellowColor}[+]${endColor} ${greenColor}Numero impar. GANASTE!! ${endColor}"
						reward=$((initial_bet * 2))
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Ganas un total de${endColor} ${yellowColor}$reward$ ${endColor}"
						money=$((money + reward))
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"
						initial_bet=$backup_initial_bet
						bad_plays=""
					fi
				else
					echo -e "${yellowColor}[+]${endColor} ${redColor}Numero par. Perdiste!! ${endColor}"
					echo -e "${yellowColor}[+]${endColor} ${greyColor}Saldo total:${endColor} ${yellowColor}$money$ ${endColor}"
					initial_bet=$((initial_bet * 2))
					bad_plays+="$random_number "
				fi
			fi
		else
			echo -e "\n ${redColor}[x] Te has quedado sin pasta CABRON!!${endColor}\n"

			echo -e "\n${yellowColor}[!!]${endColor} ${greyColor}Han habido un total de${endColor} ${yellowColor}$play_counter${endColor} ${greyColor}jugadas!!${endColor}"
			echo -e "\n${yellowColor}[!!]${endColor} ${greyColor}Se representan las -> ${endColor} ${yellowColor}$bad_plays${endColor} ${greyColor}jugadas malas consecutivas${endColor}"
			tput cnorm
			exit 0
		fi
		let play_counter+=1

	done
	tput cnorm
}

function inverseLabrouchere() {
	echo -e "\n${turquesaColor}[!]${endColor} ${greyColor}Cantidad de dinero actual${endColor} ${blueColor}$money${endColor}"
	echo -ne "${yellowColor}[+]${endColor} ${greyColor}Seleccione un si desea apostar a (par/impar):${endColor} " && read par_impar

	#! incio de mi array
	declare -a my_secuence=(1 2 3 4)

	#! suma de mis extremos array
	bet=$((${my_secuence[0]} + ${my_secuence[-1]}))

	#! OUTPUTS
	echo -e "\n${yellowColor}[!!]${endColor} ${purpleColor}¡EMPEZANDO EL JUEGO!${endColor} ${yellowColor}[!!]${endColor}"
	echo -e "${turquesaColor}[!]${endColor} ${greyColor}Apostando la cantidad de dinero${endColor} ${blueColor}$bet${endColor}"
	echo -e "${turquesaColor}[!]${endColor} ${greyColor}Quedamos con la catidad de dinero${endColor} ${blueColor}$money${endColor}"
	echo -e "${yellowColor}[+]${endColor} ${greyColor}Comenzamos con la secuencia${endColor} ${turquesaColor}-> [${my_secuence[@]}]${endColor}\n"

	tput civis
	while true; do

		#! random number
		number_random=$(($RANDOM % 37))

		#! resta de money
		money=$(($money - $bet))

		echo -e "${yellowColor}[+]${endColor} ${greyColor}Invirtiendo${endColor} ${yellowColor}$bet$ ${endColor}\n"

		if [ "$money" -ge 0 ]; then
			if [ "$par_impar" == "par" ]; then
				if [ "$(($number_random % 2))" -eq 0 ] && [ "$number_random" -ne 0 ]; then

					reward=$(($bet * 2))
					money=$(($money + $reward))
					my_secuence+=($bet)
					my_secuence=(${my_secuence[@]})

					echo -e "${yellowColor}[+]${endColor} ${greyColor}Ha salido el numero${endColor} ${yellowColor}$number_random${endColor} ${greyColor}¡par! Ganas: ${endColor}${yellowColor}->$reward$<-${endColor}${greyColor} Total: ${endColor}${yellowColor}->$money$<-${endColor}"
					echo -e "${yellowColor}[+]${endColor} ${greyColor}Nueva secuencia:${endColor} ${turquesaColor}-> [${my_secuence[@]}]${endColor}\n"

					if [ "${#my_secuence[@]}" -ne 1 ]; then
						bet=$((${my_secuence[0]} + ${my_secuence[-1]}))
					elif [ "${#my_secuence[@]}" -eq 1 ]; then
						bet=${my_secuence[0]}
					fi

				elif [ "$(($number_random % 2))" -eq 1 ] || [ "$number_random" -eq 0 ]; then

					unset my_secuence[0]
					unset my_secuence[-1] 2>/dev/null
					my_secuence=(${my_secuence[@]})

					if [ "$(($number_random % 2))" -eq 1 ]; then
						echo -e "${yellowColor}[x]${endColor} ${redColor}Ha salido el numero${endColor} ${yellowColor}$number_random${endColor} ${redColor}¡impar! perdiste${endColor}${greyColor} Total: ${endColor}${yellowColor}->$money$<-${endColor}"
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Nueva secuencia:${endColor} ${turquesaColor}-> [${my_secuence[@]}]${endColor}\n"
					else
						echo -e "${yellowColor}[x]${endColor} ${redColor}Ha salido el numero${endColor} ${yellowColor}$number_random${endColor} ${redColor}CERO! perdiste${endColor}${greyColor} Total: ${endColor}${yellowColor}->$money$<-${endColor}"
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Nueva secuencia:${endColor} ${turquesaColor}-> [${my_secuence[@]}]${endColor}\n"
					fi

					if [ "${#my_secuence[@]}" -eq 0 ]; then
						my_secuence=(1 2 3 4)
						echo -e "${redColor}[-] Se ha perdido la secuencia${endColor}"
						echo -e "${yellowColor}[+]${endColor} ${greyColor}Restableciendo la secuencia:${endColor} ${turquesaColor}-> [${my_secuence[@]}]${endColor}\n"
						bet=$((${my_secuence[0]} + ${my_secuence[-1]}))
					elif [ "${#my_secuence[@]}" -ne 1 ]; then
						bet=$((${my_secuence[0]} + ${my_secuence[-1]}))
					elif [ "${#my_secuence[@]}" -eq 1 ]; then
						bet=${my_secuence[0]}
					fi
				fi
			else
				echo -e "nada que mostrar"
			fi
			sleep 0
		else
			echo -e "\n ${redColor}[x] Te has quedado sin pasta CABRON!!${endColor}\n"
			tput cnorm
			exit 0
		fi
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
	elif [ $technique == "inverseLabrouchere" ]; then
		inverseLabrouchere
	else
		echo -e "\n ${redColor}[x] La tecnica introducida no existe${endColor}"
		helpPanel
	fi
else
	helpPanel
fi
