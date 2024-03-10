:!UTF-8
/* Wykonania,
   Parametry:
            _a - data od  (np. 2007 musi być wypełnione)
            _b - data do(musi być wypełnione)
            _c - zlecenia  (* - wszystkie zlecenia)
            _d - wydział (* - wszystkie)
  */
select
   0 as LP,
   OKR.NAZ as Okres,
   ZGP.ENDD "Datsa pl.",
   ZLGD.DT as Data,
   ZLGD.ZMIANA as Zmiana,
   UD_SKL.SYMBOL as Wydział,
   KH.SKR as "Kontrah.",
   M.KTM as KTM,
   M.N as "Wyrób",
   ZGH.NRPRZ as "Symbol przew.",
   ZGP.NRP as "Nr",
   case when ZGP.DOK is not null then 'RP' else '' end as RP,
   ZGP.OPIS as Operacja,
   TWRKPLC.KOD as Stanowisko,
   max(ZGP.ILOSC) as "Ilość (N)",
   sum(ZLGD.IL) as Ilość,
   sum(ZLGD.ILGEN) as "Ilość RP",
   max(ZGP.NTIME) as "Czas (N)",
   sum(ZLGD.TIME) as Czas
from @ZLGD
   join UD_SKL using(ZLGD.WYD,UD_SKL.REFERENCE)
   join OKR using(ZLGD.O,OKR.REFERENCE)
   join @ZLGB using(ZLGB.ZLGD,ZLGD.REFERENCE)
   join ZL using(ZLGD.ZL,ZL.REFERENCE)
   join M using(ZL.KTM,M.REFERENCE)
   left join KH using(ZL.KH,KH.REFERENCE)
   join ZGP using(ZLGD.ZGP,ZGP.REFERENCE)
   join ZGH using(ZGP.NRPRZ,ZGH.REFERENCE)
   join TWRKPLC using(ZGP.PLACE,TWRKPLC.REFERENCE)
where (UD_SKL.SYMBOL like ':_d%' or (':_d'='%'))
   and ZLGD.DT>=to_date(:_a) and ZLGD.DT<=to_date(:_b)
   and (ZL.SYM like ':_c%' or (':_c'='%'))
group by OKR.NAZ, ZGP.ENDD, ZLGD.DT, ZLGD.ZMIANA, UD_SKL.SYMBOL, KH.SKR, M.KTM, M.N, ZGH.NRPRZ, ZGP.NRP, (case when ZGP.DOK is not null then 'RP' else '' end), ZGP.OPIS, TWRKPLC.KOD

order by Okres, Data, Zmiana

