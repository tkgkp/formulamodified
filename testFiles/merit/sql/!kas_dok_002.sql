:!UTF-8
select
 0 as LP,
 RAPORT.NUM_RAP as "Numer raportu",
 DOKUMENT.LP as "Numer dokumentu",
 OSOBA.PIERWSZE as "Imię pracownika",
 OSOBA.NAZWISKO as "Nazwisko pracownika",
 EZAL.DATA_WY as "Data wydania zaliczki",
 EZAL.SYM as "Symbol zaliczki",
 POZDOK.KW_WAL as "Kwota zaliczki",
 SLO.KOD as "Waluta",
 case
  when DOKUMENT.PLUS_MIN='+' then 'Wpłata'
  else 'Wypłata'
 end as "Wpłata/Wypłata"

from
 @EZALPOZ
 left join EZAL using (EZALPOZ.EZAL,EZAL.reference)
 left join OSOBA using (EZAL.ZAL_DLA,OSOBA.reference)
 left join SLO using (EZAL.WAL,SLO.reference)
 join POZDOK using (EZALPOZ.POCH,POZDOK.reference)
 left join DOKUMENT using (POZDOK.DOKUMENT,DOKUMENT.reference)
 left join RAPORT using (DOKUMENT.RAPORT,RAPORT.reference)

where
 ((EZAL.DATA_WY between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null)) and
 (':_c'='Wszystkie' or (':_c'='Wypłaty' and DOKUMENT.PLUS_MIN='-') or (':_c'='Wpłaty' and DOKUMENT.PLUS_MIN='+'))
 
order by "Numer raportu","Numer dokumentu","Data wydania zaliczki"

