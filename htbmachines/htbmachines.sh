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


# Variables globales
main_url="https://htbmachines.github.io/bundle.js"


# Funciones
ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...\n${endColour}"
  tput cnrom; exit 1
}

helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de máquina${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por dirección IP${endColour}"
  echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por dificultad de una máquina${endColour}"
  echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar por sistema operativo${endColour}"
  echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar por las Skills${endColour}"
  echo -e "\t${purpleColour}l)${endColour}${grayColour} Obtener link de la resolución de la máquina en youtube${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar panel de ayuda${endColour}\n"
}




updateFiles(){
  # Ocultamos el cursor
  tput civis

  if [ ! -f bundle.js ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios... ${endColour}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos an sido descargados ${endColour}"

  
    # Mostramos el cursor
    tput cnorm
  else
    # Ocultamos el cursor
    tput civis
    echo -e "\n${yellowColour}[!]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...${endColour}"
    
    # Descargamos el archivo
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    # Comprobamos si el archivo a sido actualizado
    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones, lo tienes todo al dia ;)${endColour}"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles${endColour}"
      sleep 1

      # Borramos y renombramos el nuevo archivo
      rm bundle.js && mv bundle_temp.js bundle.js

      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos an sido actualizados${endColour}"
    fi

    # Mostramos el cursor
    tput cnorm
      
  fi
}

fieldMachine(){
  field="$2"
  machineName="$1"
  # Comando
  echo -e "${purpleColour}$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "$field:" | tr -d ':' | awk '{print $1}' NF=':')${endColour}${grayColour} : ${endColour}${grayColour}$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "$field:"| sed "s/$field: //g" )${endColour}" 
}


searchMachine(){
  # Variables
  machineName="$1"
  machineName_cheker="$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | grep "name:" | tr -d '",' | awk '{print $2}' NF=':')"
  
  if [ $machineName_cheker ];then

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la máquina ${blueColour}$machineName ${endColour}${grayColour}:${endColour}\n"

    # Imprimimos los resultados
    fieldMachine "$machineName" "name"
    fieldMachine "$machineName" "ip"
    fieldMachine "$machineName" "so"
    fieldMachine "$machineName" "dificultad"
    fieldMachine "$machineName" "skills"
    fieldMachine "$machineName" "like"
    fieldMachine "$machineName" "youtube"

  else
    echo -e "\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
  fi 
}

searchIP(){
  ipAddress=$1
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | tr -d '",' | awk '{print $2}' NF=':')"

  if [ $machineName ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la IP ${blueColour}$ipAddress${endColour} es ${endColour}${purpleColour}$machineName${endColour}\n"
  else
    echo -e "\n${redColour}[!] La IP proporcionada no existe${endColour}\n"
  fi
}

getYoutubeLink(){
  machineName="$1"
  youtubeLink="$(cat bundle.js| awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | egrep "youtube: " | awk '{print $2}' NF='"' | tr -d '",')"  
 
  if [ $youtubeLink ];then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El wrietup de la maquina ${blueColour}$machineName${endColour} es: ${endColour}${purpleColour}$youtubeLink${endColour}\n"
  else
    echo -e "\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
  fi
}

getMachinesdifficulty(){
  difficulty="$1"
  results_check="$(cat bundle.js| grep "dificultad: \"$difficulty\"" -B 5 | grep name |  awk '{print $NF}' | tr -d '",' | column)"

  if [ "$results_check" ];then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que tienen un nivel de difficulty ${endColour}${blueColour}$difficulty${endColour}${grayColour}:${endColour}"
    echo -e "\n${purpleColour}$results_check${endColour}"
  else
    echo -e "\n${redColour}[!] La dificultad no existe prueba con:${endColour}"
    echo -e "\t${redColour}a)${endColour} Fácil${endColour}"
    echo -e "\t${redColour}b)${endColour} Media${endColour}"
    echo -e "\t${redColour}c)${endColour} Difícil${endColour}"
    echo -e "\t${redColour}d)${endColour} Insane${endColour}"
  fi

}


getOsMachines(){
  os="$1"
  getOsMachines="$(cat bundle.js | grep "so: \"$os\"" -B 4 | grep "name: " | awk '{print $NF}' | tr -d '",' | column)\n"

  if [ "$getOsMachines" ];then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas con sistema operativo ${endColour}${blueColour}$os${endColour}${grayColour}:${endColour}" 
    echo -e "\n${purpleColour}$getOsMachines${endColour}"
  else
    echo -e "\n${redColour}[!] El sistema operativo no existe , prueba con:${endColour}"
    echo -e "\t${redColour}a)${endColour} Linux${endColour}"
    echo -e "\t${redColour}b)${endColour} Windows${endColour}\n"
  fi
}

getOsDifficultyMachines(){
  difficulty="$1"
  os="$2"
  osAndDifficultyMachines="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk '{print $NF}' | tr -d '",' | column)\n"

  if [ "$osAndDifficultyMachines" ]; then
    echo -e "\n${yellowColour}[+]${endColour} Mostrando las máquinas ${blueColour}$os${endColour}${grayColour} con dificultad ${endColour}${blueColour}$difficulty${endColour}${grayColour}:${endColour}"
    echo -e "\n${purpleColour}$osAndDifficultyMachines${endColour}"
  else
    echo -e "\n${redColour}[!] La dificultad o el sistema operativo introducidos son correctos${endColour}"
  fi
}

getMachinesSkill(){
  skills="$1"
  getMachinesSkill="$(cat bundle.js| grep "skills: " -B 6 | grep "$skills" -i -B 6 | grep "name: " | awk '{print $NF}' | tr -d '",' | column)" 
  
  if [ "$getMachinesSkill" ];then
    echo -e "\n${yellowColour}[+]${endColour} Mostrando las máquinas con la skill ${endColour}${blueColour}$skills${endColour}${grayColour}:${endColour}"
    echo -e "\n${purpleColour}$getMachinesSkill${endColour}"

  else
    echo -e "\n${redColour}[!] Alguna de la/las Skills introducidas no existen${endColour}"
  fi
}


# Ctrl+C
trap ctrl_c INT


# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

# MENU
while getopts "m:i:l:d:o:s:uh" arg; do
  case $arg in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress=$OPTARG; let parameter_counter+=3;;
    l) machineName=$OPTARG; let parameter_counter+=4;;
    d) difficulty=$OPTARG; chivato_difficulty=1; let parameter_counter+=5;;
    o) os=$OPTARG; chivato_os=1; let parameter_counter+=6;;
    s) skills=$OPTARG; let parameter_counter+=7;;
  esac
done


if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ];then
  updateFiles
elif [ $parameter_counter -eq 3 ];then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ];then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ];then
  getMachinesdifficulty $difficulty
elif [ $parameter_counter -eq 6 ];then
  getOsMachines $os 
elif [ $parameter_counter -eq 7 ];then
  getMachinesSkill "$skills"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ];then
  getOsDifficultyMachines $difficulty $os
else
  helpPanel
fi
