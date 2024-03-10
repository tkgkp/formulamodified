:!UTF-8
/* 03 Zestawienie nagłówków kart ewidencji odpadów komunalnych z definicją podsum
   Parametry:
    _a - oddział
    _b - nr rejestrowy (BDO) miejsca prowadzenia działalności
    _c - typ karty
    _d - rok
*/
select
   0 as LP,
   KEO.ODDZ as Oddział,
   KH_ODB.NRMPDBDO NrRejestrowyMPD,
   KEO.SYM as SymbolKarty,
   ODP.KOD as KodOdpadu,
   KEO.KOD_G as KodGminy,
   KEO.MASA as StanPoczątkowy,
   KEO.M_COL_M as Odebrane,
   KEO.M_REC as Przyjęte,
   KEO.M_PRO as Przetwarzane,
   KEO.M_TRA as Przekazane,
   KH_ODB.NAZ as MiejsceProwadzeniaDziałalności,
   ODP.NAZ as NazwaOdpadu,
   KEO.NAZ_G as Gmina,
   1 as Ilość
from @KEO
   left join ODP using (KEO.ODP, ODP.reference)
   left join KH_ODB using (KEO.KH_ODB,KH_ODB.REFERENCE)
where
   :_a
   and :_b
   and KEO.TYP=':_c'
   and KEO.ROK=:_d
order by 2,3,5