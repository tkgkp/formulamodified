:!UTF-8
/*
   Złożone oświadczenia PIT-12
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Badany rok podatkowy
*/
select
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE || ' ' || OSOBA.DRUGIE as "Imiona",
   OSOBA.PESEL as "PESEL",
   case
      when PIT12O.STATUS='W' then 'W - wniosek Wprowadzony'
      when PIT12O.STATUS='O' then 'O - podatek Obliczony'
      when PIT12O.STATUS='R' then 'R - podatek Rozliczony'
      else '???'
   end as "Status",
   case
      when PIT12O.STATUS='W' then '(brak obliczeń)'
      when PIT12O.NADPL>0 then 'Nadpłata'
      when PIT12O.DOZAP>=0 then 'Niedopłata'
      else '???'
   end as "Rozliczenie",
   PIT12O.LT as "Lista"
from
   PIT12O join
   P using (PIT12O.P,P.REFERENCE) join
   OSOBA using (P.OSOBA,OSOBA.REFERENCE)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   PIT12O.RP=:_b
order by
   Nazwisko,
   Imiona,
   PESEL