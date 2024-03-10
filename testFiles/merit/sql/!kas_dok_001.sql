:!UTF-8
select
 0 as LP,
 RAPORT.NUM_RAP as "Numer raportu",
 DOKUMENT.LP as "Numer dokumentu",
 OPER.KOD as "Operacja",
 HAN.NAZ as "Handlowiec",
 KH.NAZ as "Kontrahent",
 DOKUMENT.DATA as "Data pobrania",
 DOKUMENT.KW_WAL "Kwota pobrana",
 WAL.SYM "Waluta"
  
from
 @DOKUMENT
 join MBWPL using (DOKUMENT.reference,MBWPL.RSQL)
 left join RAPORT using (DOKUMENT.RAPORT,RAPORT.reference)
 left join OPER using (DOKUMENT.OPER,OPER.reference)
 left join WAL using (DOKUMENT.WALUTA,WAL.reference)
 left join KH using (MBWPL.KH,KH.reference)
 left join HAN using (MBWPL.HAN,HAN.reference)

where
 ((DOKUMENT.DATA between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
  
order by "Numer raportu","Numer dokumentu","Kwota pobrana"

