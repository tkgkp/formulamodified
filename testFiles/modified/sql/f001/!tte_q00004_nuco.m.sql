:!UTF-8
SELECT
0 as LP,
ZLSYM as "Symbol zlecenia",
 ZLO as "Opis zlecenia",
 M.KTM as "KTM produktu zlecenia",
 M.N as "Nazwa produktu zlecenia",
 NDD as "Data dokumetu magazynowego",
 SKTM as "KTM surowca/materiału",
 SN as "Nazwa surowca/materiału",
 POBR as "Pobrano",
 ZWRO as "Zwrócono",
 JM as "Jm"
from :_a TABELA
 left join M using(TABELA.PKTMREF,M.REFERENCE)
order by 1

