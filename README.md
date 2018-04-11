Teploměr Papouch TM - RS232 v Linuxu a server tmep.cz
====

Úvod
----

Cílem tohoto návodu je zprovoznit teploměr Papouch TM - RS232 v Linuxu, vyčítat z něj hodnoty teploty a ty následně zasílat na server tmep.cz který nám bude hostovat data z čidla, kreslit z nich grafy a uchovávat historii. Ukázka webového GUI například na [roudnice.eu](http://www.roudnice.eu).

Implementace
---
Připojíme čidlo přes sériový port k počítači s Linuxem. Pokud nemáme přímo port na desce, použijeme převodník.

Příkazem `dmesg | grep tty` zjistíme název sériové linky v systému. Pokud máme USB převodník, hledejte označení `ttyUSB0`. Port na desce je většinou označen jako `ttyS0`.

Vyzkoušíme komunikaci s čidlem pomocí příkazu `cat /dev/ttyUSB0`. Pokud vše funguje jak má, tak teploměr vrátí následující řádek:

`+022.7C` 

Na test to stačí, ale problémem je, že program `cat` neustále čeká na vstup, takže se aktuální teplota po čase přepíše další, to není použitelné pro další zpracování. Proto použijeme jiný způsob.

Vytvoříme skript (například `tmep.cz-logovani.sh`). První je příkaz:

`read teplota < /dev/ttyUSB0 && echo -n $teplota | tr -d "\r"`

který otevře sériovou linku, načte teplotu (pořád jako kompletní textový řetězec) a uloží do stejnojmenné proměněné . Text je poslán na vstup programu tr který odstraní "neviditelný" ASCII znak na konci řádku.

Následně pomocí curl pošleme na server tmep.cz. Před odesláním je ale ještě potřeba uříznout písmeno C a tím dostaneme pouze kladné nebo záporné číslo s jednou desetinou hodnotou:

`curl http://subdomena.tmep.cz/?nazevteplomeru=${teplota::-1}`

**subdomena** a **nazevteplomeru** jsou proměnné, které si nastavíme sami po registraci na [tmep.eu](https://www.tmep.eu)

Skript je ke stáhnutí zde: [tmep.cz-logovani.sh](tmep.cz-logovani.sh)
 
Měřit teplotu chceme pravidelně, takže do Crontabu uložíme (příkaz `crontab -e`) řádek

`*/5 * * * * bash /home/uzivatel/teplomer/logovani.sh &>/dev/null`

Skript se bude pouštět každých 5 minut (měřit častěji mi přijde zbytečné, ale samozřejmě každý podle svého gusta). Server tmep.cz má přehledné a logické nastavení, popř. doporučuji jejich [wiki](http://wiki.tmep.cz/doku.php?id=cs:start).

P.S.: Pokud nejsme root, je nutné příkazy spouštět se sudo na začátku.

Zdroje
----
* [https://www.papouch.com/cz/shop/product/tm-rs232-teplomer/](https://www.papouch.com/cz/shop/product/tm-rs232-teplomer)
* [http://www.abclinuxu.cz/poradna/linux/show/241310/](http://www.abclinuxu.cz/poradna/linux/show/241310)
* [http://wiki.tmep.cz/doku.php?id=zarizeni:vlastni_hardware](http://wiki.tmep.cz/doku.php?id=zarizeni:vlastni_hardware)

*Kopie tohoto textu je na mém blogu: <https://8khz.blogspot.cz/2017/01/teplomer-papouch-tm-rs232-v-linuxu.html>*
