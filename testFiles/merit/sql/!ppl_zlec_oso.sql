:!UTF-8
/*
   Osoby, którym wypłacono wynagrodzenie
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Rok do analizy danych
      :_c - Miesiąc do analizy danych
*/
select
   0 as "LP",
   RH.R as "Rok",
   RH.M as "Miesiąc",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   OSOBA.PESEL as "PESEL",
   count(DISTINCT RH.REFERENCE) "Liczba rachunków",
   sum(case when R.RN=500 then LS.KW else 0 end) as "Brutto",
   sum(case when R.RN=990 then LS.KW else 0 end) as "Netto",
   sum(case when R.RN=765 or R.RN=766 or R.RN=767 then LS.KW else 0 end) as "Ubezpieczenia społeczne",
   sum(case when R.RN=797 or R.RN=798 or R.RN=792 then LS.KW else 0 end) as "Zaliczka na podatek i ubezpieczenie zdrowotne",
   sum(case when R.RN=958 or R.RN=959 or R.RN=960 then LS.KW else 0 end) as "Ubezpieczenia społeczne - zleceniodawca",
   sum(case when R.RN=982 or R.RN=983 then LS.KW else 0 end) as "Składka FP i FGŚP",
   sum(case when R.RN=962 then LS.KW else 0 end) as "Składka FEP"
from
   R join
   @LS using(R.REFERENCE,LS.RB)
   join RH
   join O using (O.REFERENCE,RH.O)
   join ZC join
   OSOBA using(ZC.OSOBA,OSOBA.REFERENCE)
   join P using(ZC.P,P.REFERENCE)
where
   LS.REFERENCE like ('l'||SUBSTR(to_string(:_b),3,2)||'__zl%') and
   (P.REFERENCE in (select :_a.REF from :_a))
group by
   RH.R,
   RH.M,
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE,
   OSOBA.PESEL
having
   RH.R=:_b and (RH.M=:_c or :_c=0)




