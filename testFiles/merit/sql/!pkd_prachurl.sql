:!UTF-8
/*
   Osoby na urlopach bezpłatnych
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
      :_c - Rubryki wg atrybutów
*/
select
distinct
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   N.OD as "Data od",
   N.DO as "Data do"
from
   N join
   R join
   P using (N.P,P.REFERENCE) join
   OSOBA
where
   N.KOR='N' and
   (P.REFERENCE in (select :_a.REF from :_a)) and
   N.OD<=to_date(:_b) and
   to_date(:_b)<=N.DO and
   R.RN in (:_c)
order by
   Nazwisko,
   Imię
