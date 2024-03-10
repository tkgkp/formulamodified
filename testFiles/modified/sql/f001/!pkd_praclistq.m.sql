:!UTF-8
/*
   NUCO - Lista współpracowników
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
*/
select
   distinct
   0 as "LP",
   to_string(P.DZA) as "Zatr_od",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   P.T as "Teczka",
   UD_SKL.SYMBOL as "Jednostka organizacyjna",
   STN.ST as "Stanowisko",
   STN.K as "Kierownik",
   H.RWYL || '/' || H.RWYM "Wymiar",
   H.S1 as "Płaca_zasadnicza",
   OSOBA.PESEL as "PESEL",
   to_string(OSOBA.UR_DATA) as "Data_Ur",
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