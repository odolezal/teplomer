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

Integrace se serverem TMEP.cz
---
- Skript včetně okomentovaných příkazů je ke stáhnutí zde: [teplomer.sh](teplomer.sh).
- `tmep_subdom` a `tmep_guid` jsou parametry, které si nastavíme sami po registraci na [tmep.cz](https://www.tmep.cz).

 
Měřit teplotu chceme pravidelně, takže do crontabu uložíme (příkaz `crontab -e`) řádek

`*/5 * * * * bash /home/uzivatel/teplomer/logovani.sh &>/dev/null`

Skript se bude pouštět každých 5 minut (měřit častěji mi přijde zbytečné, ale samozřejmě každý podle svého gusta). Server tmep.cz má přehledné a logické nastavení, popř. doporučuji jejich [wiki](http://wiki.tmep.cz/doku.php?id=cs:start).

P.S.: Pokud nejsme root, je nutné příkazy spouštět se sudo na začátku.

Zdroje
----
* [https://www.papouch.com/cz/shop/product/tm-rs232-teplomer/](https://www.papouch.com/cz/shop/product/tm-rs232-teplomer)
* [http://www.abclinuxu.cz/poradna/linux/show/241310/](http://www.abclinuxu.cz/poradna/linux/show/241310)
* [http://wiki.tmep.cz/doku.php?id=zarizeni:vlastni_hardware](http://wiki.tmep.cz/doku.php?id=zarizeni:vlastni_hardware)

*Kopie tohoto textu je na mém blogu: <https://8khz.blogspot.cz/2017/01/teplomer-papouch-tm-rs232-v-linuxu.html>*

Teploměr Česká
---------------
* ~~Měření teploty je realizováno pomocí počítače Raspberry Pi 3, ke kterému je připojen přes sériové rozhraní teploměr [Papouch TM](https://www.papouch.com/cz/shop/product/tm-rs232-teplomer/). Internetová konektivita je řešena pomocí bezdátové sítě.~~
* Na adrese [ceska.tmep.cz](http://ceska.tmep.cz) jsou výstupy z teploměru umístěného v obci Česká.
* Ve složce [/db](/db) jsou nepravidelné zálohy databáze měření k volnému užití.
* Aktuální data lze stahovat ve formátu:
  * JSON: https://tmep.cz/vystup-json.php?id=621&export_key=pwtmlr7yhk 
  * XML: https://tmep.cz/vystup-XML.php?id=621&export_key=pwtmlr7yhk
* Widget pro iOS a Android: https://tmep.cz/index.php?androidWidget=621
