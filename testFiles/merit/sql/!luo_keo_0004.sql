:!UTF-8
/* 04 Zestawienie nagłówków kart ewidencji odpadów niebezpiecznych z definicją podsum
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
   KH_ODB.NAZ as MiejsceProwadzeniaDziałalności,
   KEO.SYM as SymbolKarty,
   ODP.KOD as KodOdpadu,
   ODP.NAZ as NazwaOdpadu,
   KEO.MASA as StanPoczątkowy,
   KEO.M_HAZ as Masa,
   KEO.M_HAZ_BR as MasaWZakresieSprzedaży,
   KEO.M_HAZ_DE as MasaWZakresiePośrednictwa,
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