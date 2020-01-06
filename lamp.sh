#!/bin/bash

# Start LAMP 1.0.1
# Author and copyright (C): Marcello Vitagliano
# License: GNU General Public License


echo -e '\033]2;LAMP\007';

while [[ $opzione != x ]]; 

do

	clear;

	echo -e "\n  \e[1m---- START / STOP - APACHE / MYSQL ----\e[0m \n";
	echo -e "  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯";

	echo -e "\n  \e[1;42m a \e[0m Avvia Apache e MySQL            \e[1;41m f \e[0m Ferma Apache e MySQL \n\n  \e[1;44m r \e[0m Riavvia Apache                  \e[1;44m p \e[0m Ricarica configurazione php.ini \n\n  \e[1;41m b \e[0m Abilita Apache/MySQL al boot    \e[1;41m d \e[0m Disabilita Apache/MySQL al boot  \n\n  \e[1;105m c \e[0m Controlla lo stato              \e[1;100m x \e[0m Esci\n\n";

	if [ "`systemctl is-active apache2.service`" == "active" ] 
		then 
			echo -e "  \e[92m⚫\e[0mApache in esecuzione";
		else
			echo -e "  \e[31m◼\e[0m Apache fermo";
	fi 

	if [ "`systemctl is-active mysql.service`" == "active" ] 
		then 
			echo -e "  \e[92m⚫\e[0mMySQL in esecuzione\n";
		else
			echo -e "  \e[31m◼\e[0m MySQL fermo\n";
	fi 

	read opzione;

	if [ $opzione == "a" ]; then
		
		systemctl start apache2.service
		systemctl start mysql.service
		systemctl -q is-active apache2 && echo -e "  \e[92m⚫\e[0mApache avviato" || echo -e "  \e[1;31mApache NON AVVIATO \e[0m" 
		systemctl -q is-active mysql && echo -e "  \e[92m⚫\e[0mMySQL avviato" || echo -e "  \e[1;31mMySQL NON AVVIATO \e[0m"
		sleep 2
		clear;
		
	elif [ $opzione == "f" ]; then	
		
		systemctl stop apache2.service
		systemctl stop mysql.service
		systemctl -q is-active apache2 && echo -e "  \e[1;31mApache NON FERMATO \e[0m" || echo -e "  \e[31m◼\e[0m Apache fermato"
		systemctl -q is-active mysql && echo -e "  \e[1;31mMySQL NON FERMATO \e[0m" || echo -e "  \e[31m◼\e[0m MySQL fermato"
		sleep 2
		clear;
				
	elif [ $opzione == "r" ]; then
		
		sudo systemctl restart apache2.service
		echo -e "  \e[95m🔃\e[0mApache riavviato"
		sleep 2
		clear;		
		
	elif [ $opzione == "p" ]; then
		
		sudo systemctl reload apache2.service
		echo -e "  \e[95m🔃\e[0mConfigurazione php.ini ricaricata"
		sleep 2
		clear;
		
	elif [ $opzione == "b" ]; then	
		
		systemctl enable apache2.service
		systemctl enable mysql.service
		sleep 2
		clear;
				
	elif [ $opzione == "d" ]; then	
		
		systemctl disable apache2.service
		systemctl disable mysql.service
		sleep 2
		clear;
				
	elif [ $opzione == "c" ]; then	

		printf "\n  \e[1mApache: \e[0m" 
		systemctl status apache2.service | grep -Po 'Active: \K.*'
		printf "  Partenza al boot: " 
		systemctl is-enabled apache2
		
		printf "\n  \e[1mMySQL: \e[0m" 
		systemctl status mysql.service | grep -Po 'Active: \K.*'
		printf "  Partenza al boot: " 
		systemctl is-enabled mysql
		
		sleep 8
		clear;
		
	fi

done