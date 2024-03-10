:!UTF-8
select
0 as LP,
M.KTM Kod,
M.N Nazwa,
KK.SYM Konto,
KK.NAZWA Opis,
sum(DK.IL) Ilośc,
sum(DK.WAR) Wartość,
KH.SKR as Kontrahent,
M.WN as wNetto,
M.WB as wBrutto,
sum(DK.IL*M.WN) as sumNetto,
sum(DK.IL*M.WB) as sumBrutto
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join KK using (ND.KK,KK.REFERENCE) 
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join KH using (ND.KH, KH.REFERENCE)
   left join DK_C using(DK.DK_C,DK_C.REFERENCE)
where  MG.SYM=':_a' and TYPYDOK.T=':_b' and ND.D between to_date(:_c) and to_date(:_d) and ND.Z='T' 
group by M.KTM,M.N,KK.SYM,KK.NAZWA,KH.SKR,M.WN,M.WB
order by 2,4,5
