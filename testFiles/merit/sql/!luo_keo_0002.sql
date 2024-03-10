:!UTF-8
/* 02 Zestawienie nagłówków kart ewidencji odpadów z definicją podsum
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
   KEO.MASA as StanPoczątkowy,
   KEO.M_GEN_I as WytworzoneWewInstalacji,
   KEO.M_GEN_E as WytworzonePozaInstalacją,
   KEO.M_GEN_SI as WytworzoneZUsługWewInstalacji,
   KEO.M_GEN_SE as WytworzoneZUsługPozaInstalacją,
   KEO.M_EXC as Wydobyte,
   KEO.M_COL as Przyjęte,
   KEO.M_TRE as Przetwarzane,
   KEO.M_PCB as ZawartośćPCB,
   KEO.M_FOR_C as PrzekazaneWKraju,
   KEO.M_FOR_A as PrzekazaneZaGranica,
   KH_ODB.NAZ as MiejsceProwadzeniaDziałalności,
   ODP.NAZ as NazwaOdpadu,
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