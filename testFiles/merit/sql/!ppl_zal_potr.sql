:!UTF-8
/*
   Potrącenia automatyczne zaliczek
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data od
      :_c - Data do
*/
select
distinct
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   EZAL.SYM as "Symbol",
   KOM_OS.WART as "Kwota",
   KOM_OS.OD as "Data od",
   EZAL.ZAM as "Zamknięta"
from
   EZAL join
   KOM_OS using(EZAL.REFERENCE, KOM_OS.EZAL) join
   OSOBA using(OSOBA.REFERENCE, KOM_OS.OSOBA) join
   P using(OSOBA.REFERENCE, P.OSOBA)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   KOM_OS.OD<=to_date(:_c) and
   to_date(:_b)<=KOM_OS.OD
order by
   Nazwisko,
   Imię

