:!UTF-8
/*
   NUCO - Moja lista współpracowników
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
*/
select
   distinct

   0 as "LP",
   UD_SKL.SYMBOL as "Jednostka organizacyjna",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   to_string(P.DZA) as "Zatr_od",
   to_string(P.DZ) as "Do dnia",
   P.ZA as "Zatr",
   1 Liczba
from
   H join
   STN  using(H.ST,STN.REFERENCE) join
   UD_SKL using (H.WYDZIAL,UD_SKL.REFERENCE) join
   P using (H.P,P.REFERENCE) join
   OSOBA
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   H.OD<=to_date(:_b) and (H.DO is null or to_date(:_b)<=H.DO)
order by
   3,
   4