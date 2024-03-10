:!UTF-8
/*
   Umowy na zastępstwo
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Data badania
*/
select
   0 as "LP",
   H_UM.OD as "Data rozpoczęcia",
   H_UM.DO as "Data zakończenia",
   OSOBA.NAZWISKO as "Nazwisko",
   OSOBA.PIERWSZE as "Imię",
   P.T as "Teczka",
   UD_SKL.SYMBOL as "Jednostka organizacyjna",
   STN.ST as "Stanowisko",
   H.RWYL || '/' || H.RWYM "Wymiar zatrudnienia",
   P_ZAS.T as "Teczka (zastępowany)",
   OSO_ZAS.NAZWISKO as "Nazwisko (zastępowany)",
   OSO_ZAS.PIERWSZE as "Imię (zastępowany)",
   UD_ZAS.SYMBOL as "Jednostka (zastępowany)",
   STN_ZAS.ST as "Stanowisko (zastępowany)"
from
   H join
   H_UM using (H.UMOWA,H_UM.REFERENCE) join
   STN using (H.ST,STN.REFERENCE) join
   UD_SKL using (H.WYDZIAL,UD_SKL.REFERENCE) join
   P using (H.P,P.REFERENCE) join
   OSOBA using (P.OSOBA,OSOBA.REFERENCE) join
   P as P_ZAS using (H_UM.P_ZAS,P_ZAS.REFERENCE) join
   OSOBA as OSO_ZAS using (P_ZAS.OSOBA,OSO_ZAS.REFERENCE) join
   STN as STN_ZAS using (P_ZAS.ST,STN_ZAS.REFERENCE) join
   UD_SKL as UD_ZAS using (P_ZAS.WYDZIAL,UD_ZAS.REFERENCE)
where
   (P.REFERENCE in (select :_a.REF from :_a)) and
   H.OD<=to_date(:_b) and (H.DO is null or to_date(:_b)<=H.DO)
order by
   Nazwisko,
   Imię