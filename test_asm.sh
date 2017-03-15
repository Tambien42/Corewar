#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Create directory
if [ -d log ]
then rm -rf log
fi
mkdir log

# Assemble Champions
for champion in ./resources/players/*.s
do
	name=$(basename "$champion" .s)
	./resources/bin/asm_zaz $champion > ./log/${name}.zaz.log | mv ./resources/players/${name}.cor ./resources/players/${name}.zaz.cor
	./resources/bin/asm $champion > ./log/${name}.log
done

# Compare asm output
for champion in ./log/*.zaz.log
do
	clear
	name=$(basename "$champion" .zaz.log)
	DIFF=$(diff  ./log/${name}.log ./log/${name}.zaz.log) 
	printf "${name}\n"
	if [ "$DIFF" == "" ] 
	then
		echo "${GREEN}No difference${NC}"
	else
		echo "${RED}$DIFF${NC}"
	fi
	read -n 1 -s -p "Press any key to continue"
	printf "\n"
done

# Compare champion binary files 
for champion in ./resources/players/*.zaz.cor
do
	name=$(basename "$champion" .zaz.cor)
	hexdump -C ./resources/players/${name}.cor > champion
	hexdump -C ./resources/players/${name}.zaz.cor > champion_zaz
	cols=80
	lines=0
	clear
	while read -r a && read -r b <&3; 
	do
		if [ "$a" == "$b" ]
			then printf "${GREEN}"
			tput cup $lines 0
			printf "%s" "$a"  
			tput cup $lines $cols
			printf "%s" "$b"
			printf "${NC}\n";
		else
			printf "${RED}"
			tput cup $lines 0
			printf "%s" "$a"  
			tput cup $lines $cols
			printf "%s" "$b" 
			printf "${NC}\n";
		fi
		lines=$(($lines+1))
 	done < champion 3<champion_zaz
	read -n 1 -s -p "Press any key to continue"
	printf "\n"
done

#Rappel
#xxd -p $champion
#od -t x1 -An ./resources/players/zork.cor
#diff -W 180 -y champion champion_zaz | perl colordiff.pl | less -R