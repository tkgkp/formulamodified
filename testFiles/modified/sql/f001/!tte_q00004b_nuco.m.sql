:!UTF-8
SELECT
0 LP,
M.KTM "Indeks półproduktu/produktu",
M.N "Nazwa półproduktu/produktu",
sum(ZLILWYK) "Ilość wykonana (suma)",
SKTM "Indeks surowca",
SN "Nazwa surowca",
JM,
sum(POBR) "Ilość pobrana (suma)",
sum(ZWRO) "Ilość zwrócona (suma)",
(sum(POBR)/sum(ZLILWYK))*1000 "Średnia gramatura",
'g' "JM gramatury"
from :_a TABELA
left join M using(TABELA.PKTMREF,M.REFERENCE)
group by M.KTM,M.N,SKTM,SN,JM
having sum(ZLILWYK)<>0 and SN like 'm.%' and M.N not like 'm.%'