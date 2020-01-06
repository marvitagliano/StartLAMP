# StartLAMP

Script Bash per avviare Apache e MySQL contemporaneamente: richiede systemd, il sistema di init già installato di default a partire da Ubuntu 15.04 e da Debian 8.

È possibile richiamare direttamente lo script .sh nel Terminale oppure eseguirlo, più velocemente, da un Avviatore o inserendo quest'ultimo nel pannello così da averlo sempre a portata di mano.

Occorre modificare il file "lamp" (l'avviatore .desktop) cambiando, nel codice, i due percorsi al file .sh e all'icona .png (Exec e Icon).

Infine, rendere eseguibile lo script con chmod +x lamp.sh

Ecco lo script in esecuzione: <img src="https://i.imgur.com/ocayFrG.png" />
