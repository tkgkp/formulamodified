:!UTF-8
/*
   Zaliczki wprowadzone automatycznie
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
   ZALICZ.KW as "Kwota",
   ZALICZ.DWP as "Data",
   ZALICZ.LT as "Lista",
   EZAL.ZAM as "Zamknięta"
from
   EZAL join
   ZALICZ using(EZAL.REFERENCE, ZALICZ.EZAL) join
   OSOBA using(OSOBA.REFERENCE, ZALICZ.OSOBA) join
   P using(OSOBA.REFERENCE, P.OSOBA)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   ZALICZ.DWP<=to_date(:_c) and
   to_date(:_b)<=ZALICZ.DWP
order by
   Nazwisko,
   Imię

