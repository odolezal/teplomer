#!/bin/bash
#Vyctu hodnotu teploty z cidla a ulozim do promene teplota,
read teplota < /dev/ttyUSB0 && echo -n $teplota | tr -d "\r"
#nasledne uriznu pismeno C abych dostal jen cislo
#nakonec poslu na server tmep.cz ktery udela vse ostatni
curl http://subdomena.tmep.cz/?nazevteplomeru=${teplota::-1}
#konec
