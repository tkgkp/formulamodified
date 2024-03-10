:!UTF-8
/*
   Lista osób kończących współpracę w okresie
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data od
      :_c - Data do
*/
select
distinct
   0 as "LP",
   P.DZ as "Data zwolnienia",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   P.T as "Teczka",
   UD_SKL.SYMBOL as "Jednostka organizacyjna",
   STN.ST as "Stanowisko",
   H.RWYL || '/' || H.RWYM as "Wymiar zatrudnienia"
from
   H join
   STN using (H.ST,STN.REFERENCE) join
   UD_SKL using (H.WYDZIAL,UD_SKL.REFERENCE) join
   P using (H.P,P.REFERENCE) join
   OSOBA
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   H.DO is not null and H.DO=P.DZ and
   to_date(:_b)<=H.DO and H.DO<=to_date(:_c)
order by
   Nazwisko,
   Imię