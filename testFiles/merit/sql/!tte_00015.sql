:!UTF-8
/* Wykonania,
   Parametry:
            _a - numer roku  (np. 2007 musi być wypełnione)
            _b - numer okresu (musi być wypełnione)
            _c - zlecenia  (* - wszystkie zlecenia)
            _d - nazwisko pracownika(* - wszyscy pracownicy)
  */
select
   0 as LP,
   OKR.NAZ as Okres,
   ZLGD.DT as Data,
   ZLGD.ZMIANA as Zmiana,
   UD_SKL.SYMBOL as Wydział,
   ZL.SYM as Zlecenie,
   ZGP.OPIS as Operacja,
   OSOBA.NAZWISKO as Nazwisko,
   OSOBA.PIERWSZE as Imię,
   TWRKPLC.KOD as Stanowisko,
   sum(ZLGB.IL) as Ilość,
   sum(ZLGB.IL_BRAK) as Braki,
   sum(ZLGB.TIME) as Czas,
   sum(ZLGB.KW) as Kwota
from @ZLGD
   join UD_SKL using(ZLGD.WYD,UD_SKL.REFERENCE)
   join OKR using(ZLGD.O,OKR.REFERENCE)
   join @ZLGB using(ZLGB.ZLGD,ZLGD.REFERENCE)
   join P using(ZLGB.P,P.reference)
   join OSOBA using(P.OSOBA,OSOBA.REFERENCE)
   join ZL using(ZLGD.ZL,ZL.REFERENCE)
   join ZGP using(ZLGD.ZGP,ZGP.REFERENCE)
   join TWRKPLC using(ZGP.PLACE,TWRKPLC.REFERENCE)
where ( OSOBA.NAZWISKO like ':_d%' or (':_d'='%'))
   and OKR.ROK=:_a and OKR.MC=:_b
   and (ZL.SYM like ':_c%' or (':_c'='%'))
group by OKR.NAZ, ZLGD.DT, ZLGD.ZMIANA, UD_SKL.SYMBOL, ZL.SYM, ZGP.OPIS, OSOBA.NAZWISKO, OSOBA.PIERWSZE, TWRKPLC.KOD

order by Okres, Data, Zmiana

