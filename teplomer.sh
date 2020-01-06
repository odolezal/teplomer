#Integrace se serverem TMEP.cz pro RS232 teplomer Papouch TM.
#https://github.com/odolezal/teplomer
#verze: 2.0
#=====================================

#!/bin/bash

#Casove razitko
now=$(date +"%H:%M:%S, %d.%m.%Y")

#Subdomena na serveru TMEP.cz
tmep_subdom="subdomena"

#GUID na serveru TMEP.cz
tmep_guid="xxxyyyzzz"

#Rozhrani seriove linky (zjistime napr. prikazem "ls -l /dev/tty*")
serial_port="/dev/ttyUSB0"

#Vyctu hodnotu teploty z cidla a ulozim do promene "teplota".
read teplota < "$serial_port" && echo -n $teplota | tr -d "\r" &>/dev/null

#Konstrukce "${teplota:2:-1}" urizne pismeno "C" z konce a "+" a "0" ze zacatku textoveho retezce.

#Debug (mozno zakomentovat):
echo "================================="
echo "Cas a datum:" "$now"
echo "Teplota:" "${teplota:2:-1}" "°C"

#Poslu HTTP pozadavek na server TMEP.cz
curl "http://${tmep_subdom}.tmep.cz/?${tmep_guid}=${teplota::-1}"
