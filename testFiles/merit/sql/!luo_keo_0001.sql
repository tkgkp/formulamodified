:!UTF-8
/* 01 Zestawienie wpisów kart ewidencji odpadów z definicją podsum
   Parametry:
    _a - oddział
    _b - nr rejestrowy (BDO) miejsca prowadzenia działalności
    _c - data wpisu od (może być 0000/00/00, wtedy od dowolnej daty)
    _d - data wpisu do (może być 0000/00/00, wtedy do dowonlej daty)
    _e - typ karty
    _f - rodzaj odpadu
*/
select
   0 as LP,
   KEOP.ODDZ as Oddział,
   KH_ODB.NRMPDBDO NrRejestrowyMPD,
   KH_ODB.NAZ as MiejsceProwadzeniaDziałalności,
   KEO.SYM as SymbolKarty,
   KEOP.DT as Data,
   KEOP.TYP as TypWpisu,
   ODP.KOD as KodOdpadu,
   ODP.NAZ as NazwaOdpadu,
   KEOP.INSTALLN as NazwaInstalacji,
   (KEOP.MASA_INS+KEOP.MASA_EXC+KEOP.MASA) as Masa,
   1 as IlośćWpisów
from @KEOP
   left join @KEO using (KEOP.KEO, KEO.REFERENCE)
   left join ODP using (KEO.ODP, ODP.REFERENCE)
   left join KH_ODB using (KEO.KH_ODB,KH_ODB.REFERENCE)
   left join KH using (KH_ODB.KH,KH.REFERENCE)
where
   :_a
   and :_b
   and KEO.TYP=':_e'
   and :_f
   and ((KEOP.DT between to_date(:_c) and to_date(:_d)) or
       (:_c='0000-0-0' and :_d='0000-0-0') or
       (KEOP.DT>to_date(:_c) and :_d='0000-0-0') or
       (KEOP.DT<to_date(:_d) and :_c='0000-0-0'))
order by 2,3,5,6