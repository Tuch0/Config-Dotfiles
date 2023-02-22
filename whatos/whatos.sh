#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Variables generales
ip=$1
ttl=$(ping -c 1 $ip 2>/dev/null | head -n 2 | tail -n 1 | awk '{print $6}' NF=" " | sed 's/ttl=//g' 2>/dev/null)


# Funciones
colourMessages(){
  # Vars
  bracket="$1"; colour="$2"; message="$3"; unicolor="$4"

  # Condicionales
  if [ "$colour" == "green" ];then colour="\e[0;32m\033[1m"
  elif [ "$colour" == "red" ];then colour="\e[0;31m\033[1m"
  elif [ "$colour" == "blue" ];then colour="\e[0;34m\033[1m"
  elif [ "$colour" == "yellow" ];then colour="\e[0;33m\033[1m"
  elif [ "$colour" == "purple" ];then colour="\e[0;35m\033[1m"
  elif [ "$colour" == "turquoise" ];then colour="\e[0;36m\033[1m"
  elif [ "$colour" == "gray" ];then colour="\e[0;37m\033[1m"; fi
  if [ "$unicolor" == "t" ] || [ "$unicolor" == "y" ];then unicolor=$colour; fi

  # Creator
  echo -e "${colour}${bracket}${endColour}${grayColour}${unicolor} $message${endColour}${endColour}"
}

# Comprobador
if [ "$ip" == "" ];then colourMessages "\n[>]" "purple" "Ejemplo de uso: ${blueColour}$0${endColour} ${grayColour}193.23.2.123${endColour}\n"; exit 1; fi

if [ $ttl -gt 0 2>/dev/null ] && [ $ttl -lt 64 2>/dev/null ];then
  colourMessages "\n[+]" "yellow" "Sistema operativo ${blueColour}Linux${endColour} : ${purpleColour}$ip${endColour}\n"
elif [ $ttl -gt 64 2>/dev/null ] && [ $ttl -lt 128 2>/dev/null ];then
  colourMessages "\n[+]" "yellow" "Sistema operativo ${blueColour}Windows${endColour} : ${purpleColour}$ip${endColour}\n"
else
  colourMessages "\n[!]" "red" "La ip introducida no existe o esta actualmente inactiva :(\n" "y"
fi
