#!/bin/bash
#docmeth
#last edit 27-02-2018 13:00
#---------------------#
IP=10.10.10.81:80     #<-- CHANGE THE IP : PORT AS NEEDED
DOMEX=".bart.htb"     #<-- CHANGE THIS (REMEMBER THE 'DOT' MUST BE IN PLACE!) 
#---------------------#
#
STD=$(echo -e "\e[0;0;0m")		#Revert fonts to standard colour/format
REDN=$(echo -e "\e[0;31m")		#Alter fonts to red normal
GRNN=$(echo -e "\e[0;32m")		#Alter fonts to green normal
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
#
WL=$1
CL=$2
START=0
DELAY=0
LENGTH=$(wc $WL | awk '{print $1}')
#
if [ $# -eq 0 ] ; then 
	clear
	echo $REDN"[!]$STD Usage: bash $0 <wordlist> <known response size>"
	echo "First edit the hardcoded IP:PORT and the Domain Extension in the script on line 5 & 6"
	echo ""
	echo "Check a known response size by using a known domain/subdomain with below command;"
	echo 'curl -s --header "Host: <known_domain>.<domain_extension>" <IP_address> | wc -c'
	echo ""
	echo "Then either check against response sizes for known for domains, or"
	echo "check against a known negative response size (such as 0 for instance)"
	echo ""
	echo "Example of checking against a known response size of 35529;"
	echo " ./docmeth.sh /usr/share/seclist/Discovery/DNS/namelilst.txt 35529"
	echo ""
	echo "Example of checking against a known response size of 0 for non-existing domain" 
	echo "./docmeth.sh /usr/share/seclist/Discovery/DNS/namelilst.txt 0"
	echo "" 
	echo "Or use without any response size and manually review the output of each request;"
	echo "./docmeth.sh /usr/share/seclist/Discover/DNS/namelist.txt"
	exit
fi
#
echo "IP:PORT--- --------: $IP" 
echo "Wordlist ----------: $WL"
echo "Domain extension --: $DOMEX"
echo "Known response size: $CL"
echo ""
#
echo $BLUN"PROGRESS  --  RESPONSE SIZE  -- INPUT$STD"
while read WORD; do
	START=$(($START + 1))
	x=$(curl -s --header "Host: $WORD$DOMEX" $IP | wc -c)
	CCOUNT=$(echo "$x -- $WORD" | wc -c)
	SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
	if [ "$2" != "" ] ; then
			echo -ne "                                                     \r"
			printf '%-18s %-12s %-1s\r' "$START/$LENGTH" "$x" "$REDN$WORD$STD"
			sleep $DELAY
		if [ "$x" != "$CL" ] ; then
			printf '%-18s %-12s %-1s\n' "$START/$LENGTH" "$x" "$GRNN$WORD$STD <-- possible domain found"
		fi
	else
		printf '%-18s %-12s %-1s\n' "$START/$LENGTH" "$x" "$WORD"
	fi
done < $WL
echo $REDN"[!]$STD Completed checking wordlist $WL"
exit
