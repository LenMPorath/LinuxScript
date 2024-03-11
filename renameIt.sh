#!/bin/bash

instr="Benutzung: arg1 = Datei zur Umbenennung, arg2 = Zieldatei"

# catch wrong argument inputs
if [[ -z $1 ]];
then
	echo "Fehler: Es wurde kein Dateiname für die Verarbeitung angegeben!"
	echo $instr
	exit 1
fi

if [[ ! -e $1 ]];
then
	echo "Fehler: $1 existiert nicht!"
	echo $instr
	exit 1
fi

if [[ ! -f $1 ]];
then
	echo "Fehler: $1 ist keine Datei!"
	echo $instr
	exit 1
fi

if [[ -z $2 ]];
then
	echo "Fehler: Es wurde kein Zielname angegeben!"
	echo $instr
	exit 1
fi

# initialization of variables
originalFileName="$1"
targetFileName="$2"
point="."
origPath="$(dirname $1)"
path="$(dirname $2)"
targetPath=$PWD/$targetFileName

declare -i count=0


# check for filetype / filesuffix
if [[ ${targetFileName:1} == *.* ]];
then
	targetSuffix=$(echo "$targetFileName" | rev | cut -d'.' -f1 | rev)
	targetSuffix=$point$targetSuffix
	targetPrefix=$(basename "$targetFileName" $targetSuffix)
else
	targetPrefix=$(basename "$targetFileName")
fi

# adjust path-input for target file
if [[ $path == $point ]]; # empty path
then
	path=""
elif [[ $path == ./* ]]; # path with "./"
then
	path="${path:1}"
elif [[ $path != /* ]]; # path with "/"
then
	path="/$path"
fi

# as long as $targetPath already exists, $targetFileName has to be changed
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
echo "Pfad der neuen Datei: $targetPath"

exit 0 
