:!UTF-8
/*
   Lista współpracowników
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
*/
select
   distinct
   0 as "LP",
   P.DZA as "Data",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   P.T as "Teczka",
   UD_SKL.SYMBOL as "Jednostka organizacyjna",
   STN.ST as "Stanowisko",
   H.RWYL || '/' || H.RWYM "Wymiar zatrudnienia"
from
   H join
   STN join
   UD_SKL using (H.WYDZIAL,UD_SKL.REFERENCE) join
   P using (H.P,P.REFERENCE) join
   OSOBA
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   H.OD<=to_date(:_b) and (H.DO is null or to_date(:_b)<=H.DO)
order by
   Nazwisko,
   Imię