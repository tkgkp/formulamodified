:!UTF-8
select   OSOBA, TTUB, min(PREM) PREM, min(STNP) STNP,
         sum(POD_KC) POD_KC, sum(KC) KC

from     :_a

group by OSOBA, TTUB