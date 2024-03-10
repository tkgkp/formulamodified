:!UTF-8
SELECT
0  LP,
ZLSYM  "Symbol zlecenia",
 ZLO  "Opis zlecenia",
 M.KTM  "KTM produktu zlecenia",
 M.N  "Nazwa produktu zlecenia",
 JM  "Jm",
 ZLILWYK  "Ilosc wykonana",
 NDD "Data dokumetu magazynowego",
 SKTM "KTM surowca/materiału",
 SN  "Nazwa surowca/materiału",
 POBR  "Pobrano",
 ZWRO "Zwrócono",
 case when (SN like 'm.%' and ZLILWYK<>0 and M.N not like 'm.%') then (POBR/ZLILWYK)*1000 else 0 end "Gramatura",
'g' "Jm gramatury"
from :_a TABELA
left join M using(TABELA.PKTMREF,M.REFERENCE)


