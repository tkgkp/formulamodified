:!UTF-8
/* Wykonania,
   Parametry:
            _a - numer roku  (np. 2007 musi być wypełnione)
            _b - numer okresu (musi być wypełnione)
            _c - zlecenia  (* - wszystkie zlecenia)
  */
select
   0 as LP,
   OKR.NAZ as Okres,
   ZLGD.DT as Data,
   ZLGD.ZMIANA as Zmiana,
   SLO.KOD as Wydzial,
   ZL.ST_Z as Czy_zamkniete,
   ZL.SYM as Zlecenie,
   TKTL.NRK as NrKarty,
   M.KTM as Indeks,
   M.N as Produkt,
   ZGP.OPIS as Operacja,
   ZGH.NRPRZ as Przewodnik,
   TWRKPLC.KOD as Stanowisko,
   CASE WHEN sum(ZLGB.IL) <> 0 THEN ZGP.ILOSC
   ELSE 0
   END as Norma_ilosciowa,
   sum(ZLGB.IL) as Ilość,
   sum(ZLGB.IL_BRAK) as Braki,
   JM.KOD as JM,
   ZGP.NTIME as Norma_czasowa,
   sum(ZLGB.TIME) as Czas_rzeczywisty,
   sum(ZLGB.KW) as Kwota
from @ZLGD
   join OKR using(ZLGD.O,OKR.REFERENCE)
   join @ZLGB using(ZLGB.ZLGD,ZLGD.REFERENCE)
   join P using(ZLGB.P,P.reference)
   join ZL using(ZLGD.ZL,ZL.REFERENCE)
   join TKTL using(ZL.KTL,TKTL.REFERENCE)
   join SLO using(ZL.JORG,SLO.REFERENCE)
   join M using(ZL.KTM,M.REFERENCE)
   join JM using (M.J,JM.reference)
   join ZGP using(ZLGD.ZGP,ZGP.REFERENCE)
   join ZGH using(ZLGD.ZGH,ZGH.REFERENCE)
   join TWRKPLC using(ZGP.PLACE,TWRKPLC.REFERENCE)
where (OKR.ROK=:_a and OKR.MC=:_b)
   and (ZL.SYM like ':_c%' or (':_c'='%'))
group by OKR.NAZ, ZLGD.DT, ZLGD.ZMIANA, SLO.KOD, ZL.SYM, TKTL.NRK, ZGH.NRPRZ, M.KTM, M.N, ZGP.ILOSC, ZGP.OPIS, TWRKPLC.KOD, JM.KOD, ZGP.NTIME, ZL.ST_Z
order by Okres, Data, Zmiana

