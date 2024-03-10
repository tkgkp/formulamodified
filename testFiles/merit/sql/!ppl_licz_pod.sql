:!UTF-8
/*
   Informacje do podatku (ujęcie roczne)
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Rok podatkowy
*/
select
   0 as "LP",
   KP.R as "Rok",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   OSOBA.NIP as "NIP",
   P.T as "Teczka",
   sum(KP.S1) as "Przychód",
   sum(KP.S2) as "Koszty uzyskania",
   sum(KP.S3) as "Ulga podatkowa",
   sum(KP.S4) as "Zaliczka na podatek",
   sum(KP.S5) as "Dochód zwolniony",
   sum(KP.S6) as "Podatek zaniechany",
   sum(KP.S7) as "Podatek rozliczenie roczne",
   sum(KP.S8) as "Pobrana składka zdrowotna",
   sum(KP.S9) as "Odliczona składka zdrowotna",
   sum(KP.S10) as "Ubezpieczenia społeczne",
   sum(KP.S18) as "ZP: Przychód", 
   sum(KP.S19) as "ZP: Składki od przychodu zwolnionego od podatku", 
   sum(KP.S20) as "ZP: Składka zdrowotna"
from
   KP join
   P using (KP.P,P.REFERENCE) join
   OSOBA
where
   (P.REFERENCE in (select :_a.REF from :_a))
group by
   KP.R,
   OSOBA.NAZWISKO,
   OSOBA.PIERWSZE,
   OSOBA.NIP,
   P.T
having
   KP.R=:_b

