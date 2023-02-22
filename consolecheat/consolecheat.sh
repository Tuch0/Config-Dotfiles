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
opciones=$(cat all_data.txt| egrep "^:S.*" | uniq | sed 's/:S.//g' > .data_tmp)

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

helpPanel(){
  colourMessages "\n[+]" "yellow" "Uso:\n" 
  colourMessages "\t-h)" "blue" "Mostrar panel de ayuda" 
  colourMessages "\t-s)" "blue" "Buscar cheatsheet que deseas reportar por pantalla\n"
  colourMessages "\n[>]" "yellow" "Opciones a buscar:\n"
  echo -e "${purpleColour}$(cat .data_tmp | column)${endColour}\n"
  
  # Borramos el archivo temporal
  rm -r .data_tmp
}

buscar(){
  # Varibles generales
  palabra=":S.$buscar"
  palabra=$(echo $palabra | tr '[a-z]' '[A-Z]')
  data=$(cat all_data.txt | grep "$palabra" -A 100 | grep "$palabra" -B 100 | sed "s/$palabra//g" | egrep -v "^#")
  validador=$(cat all_data.txt | egrep "^:S.$buscar")
  code_status=$(echo $?)
  
  if [ $code_status -eq 1 ];then
    colourMessages "\n[!]" "red" "No se a podido encontrar ${blueColour}($buscar)${endColour} ${redColour}:(${endColour} " "t"
    helpPanel
  else
    colourMessages "\n[>]" "purple" "Mostrando resultado de : ${blueColour}$buscar${endColour}\n"
    echo -e "${yellowColour}$data${endColour}\n"
  fi 
  }



# Indicadores
declare -i parameter_counter=0

# Menu
while getopts "s:h" arg; do 
  case $arg in
    s) buscar=$OPTARG; let parameter_counter+=1;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ];then
  buscar
elif [ $parameter_counter -eq 0 ];then
  helpPanel
fi
