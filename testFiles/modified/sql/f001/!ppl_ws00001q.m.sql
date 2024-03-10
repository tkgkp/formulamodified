:!UTF-8
/*
   Karta zarobkowa: Brutto, Netto - NUCO
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Rok 
*/
select
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   UD_SKL.SYMBOL as "JednOrg",
   STN.ST as "Stanowisko",
   CASE WHEN KZ.M<10  THEN '0' || to_string(KZ.M)  ELSE to_string(KZ.M)  END as "Msc",
   KZ.S20 as "Brutto",
   KZ.S40 as "Netto",
   KZ.S46 as "Fund. emeryt zakł.",
   KZ.S49 as "Fund. rent. zakł.",
   KZ.S52 as "Fund. wypadkowy",
   KU.S17 as "Fund. pracy",
   KU.S18 as "Fund. gwarancyjny"
from KZ
   join P using (KZ.P,P.REFERENCE)
   join OSOBA
   left join UD_SKL using (P.WYDZIAL,UD_SKL.REFERENCE)
   left join KU using (KU.OSOBA,OSOBA.REFERENCE)
   left join STN using (P.ST,STN.REFERENCE)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   KZ.R=:_b and KU.R=:_b and KZ.M = KU.M
order by 
   2,3,4
