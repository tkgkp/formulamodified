:!UTF-8
/*
   Błędne rachunki bankowe
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
*/
select
   distinct
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   OSOBA.PESEL as "PESEL",
   B.NUMER as "Bank",
   PKO.N as "Numer konta"
from
   PKO inner join
   OSOBA inner join
   B join
   P using (P.OSOBA, OSOBA.REFERENCE)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   position(B.NUMER in PKO.N) not between 2 and 11
order by
   Nazwisko,
   Imię,
   PESEL