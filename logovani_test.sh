#Integrace se serverem TMEP.cz pro RS232 teplomer Papouch TM.
#https://github.com/odolezal/teplomer
#verze: 2.0
#=====================================

#!/bin/bash

#Start nekonecne smycky
#for (( ; ; ))
#do

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
#Pro raw hodnotu (napriklad "+023.6C") pouzijte pouze promenou "teplota".

#Debug (mozno zakomentovat):
echo "================================="
echo "Cas a datum:" "$now"
echo "Teplota:" "${teplota:2:-1}" "°C"

#Poslu HTTP pozadavek na server TMEP.cz
#curl "http://${tmep_subdom}.tmep.cz/?${tmep_guid}=${teplota::-1}"

#Test na localhostu
echo "HTTP GET:"
curl "http://127.0.0.1/teplomer/index.php?upK3FqEEcR=${teplota:2:-1}"

#Pockat X minut pred dalsim merenim.
#echo " "
#echo " "
#echo "Cekam 5 minut..."
#sleep 300

#Nekonecna smycka
#done
