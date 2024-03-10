:!UTF-8
/*
   Rachunki bankowe współpracowników
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
*/
select
distinct
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   OSOBA.PESEL as "PESEL",
   PKO.N "Numer rachunku"
from
   P join
   OSOBA left join
   PKO
where (P.REFERENCE in (select :_a.REF from :_a))
order by
   Nazwisko,
   Imię,
   PESEL