:!UTF-8
select
   0 as LP,
   FAKS.ODDZ as Oddz,
   STS.KOD as StsKod,
   FAKS.SYM as DokSym,
   to_string(FAKS.DW) as DokDataWyst,
   KH.SKR as KontrSkr,
   HAN.NAZ as HanNaz,
   to_string(FAP.POZ) as DokPoz,
   M.KTM as MatUslIndeks,
   M.N as MatUslNaz,
   FAP.IL as Ilosc,
   JM.KOD as Jm,
   FAP.WWAL_P as WarMag,
   FAP.WWAL_P as Netto,
   FAP.WWAL_P as Marza,
   FAP.VWAL_P as Vat,
   FAP.BWAL_P as Brutto,
   SLO.KOD as WAL,
   FAP.WWAL as WalNetto,
   GRKH.KOD as KontrGrupaKod,
   MGR.KOD as MatUslGrupaKod,
   FAP.REFERENCE as FapRef
from
   @FAP
   join M using (FAP.M,M.REFERENCE)
   left join JM using (FAP.JM,JM.REFERENCE)
   left join MGR using (M.MGR,MGR.REFERENCE)
   join @FAKS using (FAP.FAKS,FAKS.REFERENCE)
   join KH using (FAKS.KH,KH.REFERENCE)
   left join HAN using (FAKS.HAN,HAN.REFERENCE)
   left join STS using (FAKS.STS,STS.REFERENCE)
   left join SLO using (FAKS.WAL,SLO.REFERENCE)
   left join GRKH using (KH.GRKH,GRKH.REFERENCE)
   left join TYPYSP using(FAKS.T,TYPYSP.REFERENCE)
where
   ((FAKS.DW between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
   and :_c
   and :_d
   and :_e
   and :_f
   and :_g
   and :_h
   and :_i
   and :_j
   and FAKS.SZ='S'
   and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
order by
   2,3,4,8

