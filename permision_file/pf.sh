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


ctrl_c(){
  colourMessages "\n[!]" "red" "Saliendo...\n" "y"
  tput cnorm;exit 1
}

# ctrl_c
trap ctrl_c INT

# Variables generales
file="$1"

if [ -d $file ];then
  position=1
  permisos="$(ls -l | grep $file | awk '{print $1}' NF=" ")"
  while true;do
    cut -c $position "$permisos"
    let permisos+=1
  done
  colourMessages "\n[>]" "purple" "$file - ${blueColour}$permisos${endColour}\n"
elif [ -f $file ];then
  permisos=$(ls -l $file | awk '{print $1}' NF=" ")
  colourMessages "\n[>]" "purple" "$file - ${blueColour}$permisos${endColour}\n"
else
  colourMessages "\n[!]" "red" "El archivo introducido es inválido o no existe :(\n" "y"
fi
