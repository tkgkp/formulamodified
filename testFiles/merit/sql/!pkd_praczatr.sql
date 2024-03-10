:!UTF-8
/*
   Lista osób rozpoczynających współpracę w okresie
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data od
      :_c - Data do
*/
select
distinct
   0 as "LP",
   P.DZA as "Data zatrudnienia",
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
   H.OD=P.DZA and
   to_date(:_b)<=H.OD and H.OD<=to_date(:_c)
order by
   Nazwisko,
   Imię