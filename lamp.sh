#!/usr/bin/env bash 

# Start LAMP 1.0.5
# Author and copyright (C): Marcello Vitagliano
# License: GNU General Public License

# Imposta il titolo della finestra del terminale
echo -e '\033]2;LAMP\007'

# Funzione per controllare lo stato di Apache e MySQL
check_status() {
    # Controlla se Apache è attivo
    if systemctl is-active apache2.service >/dev/null; then
        echo -e "  \e[92m●\e[0m Apache in esecuzione"
    else
        echo -e "  \e[31m■\e[0m Apache fermo"
    fi

    # Controlla se MySQL è attivo
    if systemctl is-active mysql.service >/dev/null; then
        echo -e "  \e[92m●\e[0m MySQL in esecuzione\n"
    else
        echo -e "  \e[31m■\e[0m MySQL fermo\n"
    fi
}

# Funzione per avviare Apache e MySQL
start_services() {
    # Avvia Apache e MySQL
    sudo systemctl start apache2.service mysql.service

    # Verifica se Apache è stato avviato correttamente
    systemctl -q is-active apache2 && echo -e "  \e[92m●\e[0m Apache avviato" || echo -e "  \e[1;31m Apache NON AVVIATO \e[0m"

    # Verifica se MySQL è stato avviato correttamente
    systemctl -q is-active mysql && echo -e "  \e[92m●\e[0m MySQL avviato" || echo -e "  \e[1;31m MySQL NON AVVIATO \e[0m"
}

# Funzione per fermare Apache e MySQL
stop_services() {
    # Ferma Apache e MySQL
    sudo systemctl stop apache2.service mysql.service

    # Verifica se Apache è stato fermato correttamente
    systemctl -q is-active apache2 && echo -e "  \e[1;31m Apache NON FERMATO \e[0m" || echo -e "  \e[31m■\e[0m Apache fermato"

    # Verifica se MySQL è stato fermato correttamente
    systemctl -q is-active mysql && echo -e "  \e[1;31m MySQL NON FERMATO \e[0m" || echo -e "  \e[31m■\e[0m MySQL fermato"
}

# Funzione per riavviare Apache
restart_apache() {
    # Riavvia Apache
    sudo systemctl restart apache2.service
    echo -e "  \e[95m↻\e[0m Apache riavviato"
}

# Funzione per ricaricare la configurazione di php.ini
reload_php_config() {
    # Verifica se Apache è attivo prima di ricaricare la configurazione
    if systemctl -q is-active apache2; then
        sudo systemctl reload apache2.service
        echo -e "  \e[95m↻\e[0m Configurazione php.ini ricaricata"
    else
        echo -e "  \e[1;31m Avvia prima Apache \e[0m"
    fi
}

# Funzione per abilitare/disabilitare i servizi al boot
manage_boot() {
    local action=$1

    # Esegui l'azione (enable o disable) su Apache e MySQL
    sudo systemctl $action apache2.service
    sudo systemctl $action mysql.service

    # Messaggio personalizzato in base all'azione
    if [[ $action == "enable" ]]; then
        echo -e "  \e[95m+\e[0m Servizi abilitati al boot"
    elif [[ $action == "disable" ]]; then
        echo -e "  \e[95mX\e[0m Servizi disabilitati al boot"
    else
        echo -e "  \e[1;31m Azione non valida \e[0m"
    fi
}

# Funzione per visualizzare le versioni di Apache, PHP, MySQL
show_versions() {
    printf "\n Apache: " && apache2 -v | head -n 1 | awk -F'Apache/' '{print $2}' | awk '{print $1}'
    printf "\n PHP: " && php -v | head -n 1 | grep -oP '(?<=PHP )[\d.]+'
    printf "\n MySQL: " && mysql -V | grep -oP '[\d.]+-\w+[\d.]+'
}

# Funzione per controllare lo stato dettagliato di Apache e MySQL
show_detailed_status() {
    printf "\n  \e[1mApache: \e[0m"
    systemctl status apache2.service | grep -Po 'Active: \K.*'
    printf "  Partenza al boot: "
    systemctl is-enabled apache2

    printf "\n  \e[1mMySQL: \e[0m"
    systemctl status mysql.service | grep -Po 'Active: \K.*'
    printf "  Partenza al boot: "
    systemctl is-enabled mysql
}

# Main loop: ciclo principale del menu
while [[ $opzione != "x" ]]; do
    clear
    # Mostra il menu principale
    echo -e "\n  \e[1m---- START / STOP - APACHE / MYSQL ----\e[0m \n"
    echo -e "  \e[1m---------------------------------------\e[0m \n"

    echo -e "\n  \e[1;42m a \e[0m Avvia Apache e MySQL            \e[1;41m f \e[0m Ferma Apache e MySQL \n\n  \e[1;44m r \e[0m Riavvia Apache                  \e[1;44m p \e[0m Ricarica configurazione php.ini \n\n  \e[1;41m b \e[0m Abilita Apache/MySQL al boot    \e[1;41m d \e[0m Disabilita Apache/MySQL al boot  \n\n  \e[1;105m c \e[0m Controlla lo stato              \e[1;43m v \e[0m Versioni     \e[1;100m x \e[0m Esci\n\n"

    # Mostra lo stato corrente di Apache e MySQL
    check_status

    # Leggi l'opzione scelta dall'utente
    read -r opzione

    # Gestione delle opzioni del menu
    case $opzione in
        a) start_services; sleep 2 ;;  # Avvia Apache e MySQL
        f) stop_services; sleep 2 ;;   # Ferma Apache e MySQL
        r) restart_apache; sleep 2 ;;  # Riavvia Apache
        p) reload_php_config; sleep 2 ;;  # Ricarica la configurazione di php.ini
        b) manage_boot enable; sleep 2 ;;  # Abilita Apache e MySQL al boot
        d) manage_boot disable; sleep 2 ;;  # Disabilita Apache e MySQL al boot
        v) show_versions; sleep 8 ;;  # Mostra le versioni di Apache, PHP, MySQL
        c) show_detailed_status; sleep 8 ;;  # Mostra lo stato dettagliato dei servizi
        x) echo -e "  \e[1;100m Uscita... \e[0m"; break ;;  # Esci dallo script
        *) echo -e "  \e[1;31m Opzione non valida \e[0m"; sleep 2 ;;  # Opzione non valida
    esac
done
