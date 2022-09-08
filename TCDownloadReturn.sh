#!/bin/bash

. /usr/local/TCLib/ffmpeg-TCLib.sh 2>&1 > /dev/null

yt-dlp-tc() {
  cd $HOME/Desktop
  #echo $PWD

  format=m4a
  if [[ $2 ]] ; then
    if [[ $2 == "a" ]] ; then format="m4a" ; fi
    if [[ $2 == "v" ]] ; then format="mp4" ; fi
  fi

  if [ ! -d Scaricati ] ; then
    echo "ERROR: Non c'è la directory!"
    mkdir Scaricati
    cd Scaricati
    yt-dlp -f $format --embed-thumbnail --add-metadata "$1"
      else
      cd Scaricati
      yt-dlp -f $format --embed-thumbnail --add-metadata "$1"
  fi
}

recupera_array() {
   # ==============================
   # Recupera un array di dati da una stringa
   IFS=";"

   for p in $1 ; do
      echo "$p"
      arrLink+=("$p")
   done

   return arrLink
}


start() {

printf "Benvenuto %s.\nInserisci i/o link da scaricare: { inserisci ; tra i link }\n" $USER
read link

printf "Audio o Video? ( es. a / v )\n" $USER
read -n1 aOv

printf "\n$aOv."

if [[ "$aOv" == "a" || "$aOv" == "v" ]] ; then
  echo ""
  echo "ok Audio o Video."
  else
    echo "Scelta inesistente."
    return 1
fi

myArrLink=$(recupera_array "$link")
echo "myArrLink = -- ${myArrLink[@]} --"
for mLink in ${myArrLink[@]} ; do
   echo "mLink = ** ${mLink[@]} **"
done
# ==============================
# 
THttp=false
THttps=false

for mLink in ${myArrLink[@]} ; do
# ==============================
# Controlla i primi 4 byte per l'url
   for ((i=0; i<${#mLink}; i++)) ; do
      arrHttp+="${mLink:i:1}"
      if (( i <= 4 )) ; then
         if [[ $arrHttp == "http" ]] ; then
            THttp=true
            elif [[ $arrHttp == "https" ]] ; then
               THttps=true
         fi
      fi
   done

okLink=false

if [[ $THttp == true && $THttps == true ]] ; then
echo "link OK!"
okLink=true
   elif [[ $THttp == true && $THttps == false ]] ; then
   echo "link OK!"
   okLink=true
      elif [[ $THttp == false && $THttps == true ]] ; then
      echo "link OK!"
      okLink=true
   else
   echo "No link!"
   okLink=false
fi

if [[ $okLink == true ]] ; then
   yt-dlp-tc "$mLink" "$aOv"
   echo ""
fi

done

if [[ $aOv == "a" ]] ; then
   convert_m4a_to_mp3
fi

}

start
