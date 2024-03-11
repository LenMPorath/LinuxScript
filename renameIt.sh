#!/bin/bash

# Variableninitialisierung
originalFileName="$1"
targetFileName="$2"
point="."
origPath="$(dirname $1)"
path="$(dirname $2)"
targetPath=$PWD/$targetFileName

declare -i count=0

# Falscheingaben abfangen
if [[ ! -e $originalFileName ]];
then
	echo "Fehler: $originalFileName existiert nicht!"
	exit 1
fi

if [[ -z $targetFileName ]];
then
	echo "Fehler: Es wurde kein Zielname angegeben!"
	exit 1
fi

# Dateityp- / Dateisuffixfestlegung
if [[ ${targetFileName:1} == *.* ]];
then
	targetSuffix=$(echo "$targetFileName" | rev | cut -d'.' -f1 | rev)
	targetSuffix=$point$targetSuffix
	targetPrefix=$(basename "$targetFileName" $targetSuffix)
else
	targetPrefix=$(basename "$targetFileName")
fi

# Dateipfadeingabe für Zieldatei anpassen
if [[ $path == $point ]]; #leerer Pfad
then
	path=""
elif [[ $path == ./* ]]; #Pfad mit ./ angegeben
then
	path="${path:1}"
elif [[ $path != /* ]]; #Pfad ohne / angegeben
then
	path="/$path"
fi

# Solange es eine Datei $targetPath gibt, soll der Zielname $targetFileName verändert werden
while [[ -e $targetPath ]];
do
	targetFileName=$targetPrefix$targetSuffix
	echo "$targetFileName existiert bereits!"

	count=$count+1
	countAppandage=_$count

	targetPrefix=$(basename "$2" $targetSuffix)
	targetPrefix=$targetPrefix$countAppandage
	
	if [[ -z $targetSuffix ]];
	then
		targetFileName=$targetPrefix
	else
		targetFileName=$targetPrefix$targetSuffix
	fi
	
	targetPath=$PWD$path/$targetFileName
done

mv "$originalFileName" "$targetPath"

echo "$originalFileName wurde in $targetFileName umbenannt!"
echo "Pfad: $targetPath"
exit 0 
