:!UTF-8
/*
   Zapytanie prezentuje niesplacone umowy lojalnosciowe.
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data
*/
select
   0 as "LP",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE || ' ' || OSOBA.DRUGIE as "Imiona",
   UMLOJN.NU as "Numer umowy",
   UMLOJN.DTU as "Data zawarcia",
   UMLOJN.DTP as "Spłata od",
   UMLOJN.OKRES as "Liczba miesięcy zobowiązania",
   UMLOJN.KW as "Wartość zobowiązania",
   sum(UMLOJP.KW) as "Spłacono",
   UMLOJN.KW - case when sum(UMLOJP.KW) is null then 0 else sum(UMLOJP.KW) end as "Pozostało"
from
   UMLOJN join
   P using(UMLOJN.P,P.REFERENCE) join
   OSOBA left join
   UMLOJP using(UMLOJN.REFERENCE,UMLOJP.UMLOJN)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   UMLOJN.DTP<=to_date(:_b) and
   ( UMLOJP.DT is null or UMLOJP.DT<=to_date(:_b))
group by
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE || ' ' || OSOBA.DRUGIE,
   UMLOJN.NU,
   UMLOJN.DTU,
   UMLOJN.DTP,
   UMLOJN.OKRES,
   UMLOJN.KW
having
   UMLOJN.KW - case when sum(UMLOJP.KW) is null then 0 else sum(UMLOJP.KW) end > 0