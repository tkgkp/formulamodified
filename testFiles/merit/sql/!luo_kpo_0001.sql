:!UTF-8
select 0 as LP,
       KPO.AR as Rok,
       KPO.AM as Miesiąc,
       KPO.R as Rodzaj,
       KPO.NR as Numer,
       KPO.SYM as Symbol,
       ODP.KOD as KodOdpadu,
       ODP.NAZ as NazwaOdpadu,
       kh1.NAZ as Przekazujący,
       kh1.KPOCZ || ' ' || kh1.MIASTO || ' ' || kh1.UL as AdresPrzekazującego,
       ko1.KPOCZ || ' ' || ko1.MIASTO || ' ' || ko1.UL as MiejscePrzekazującego,
       kh2.NAZ as Przyjmujący,
       kh2.KPOCZ || ' ' || kh2.MIASTO || ' ' || kh2.UL as AdresPrzyjmującego,
       ko2.KPOCZ || ' ' || ko2.MIASTO || ' ' || ko2.UL as MiejscePrzyjmującego,
       WYS.NAZ as Składowisko,
       UL.KDP || ' ' || MIA.NAZ || ' ' || UL.UL || ' ' || WYS.NR as AdresSkładowiska,
       KPO.IL as Waga
from @KPO
     left join ODP using (KPO.ODP, ODP.reference) 
     left join KH kh1 using (KPO.KH, kh1.reference)
     left join KH_ODB ko1 using (KPO.KH_ODB, ko1.reference)
     left join KH kh2 using (KPO.KH_2, kh2.reference)
     left join KH_ODB ko2 using (KPO.KH_ODB_2, ko2.reference)
     left join WYS using (KPO.WYS, WYS.reference)
     left join UL using (WYS.UL, UL.reference)
     left join MIA using (UL.MIA,MIA.reference) 
where KPO.ODDZ=':_a' and KPO.AR=:_b and KPO.AM=:_c and KPO.R=':_d'
order by 2,3,4,5