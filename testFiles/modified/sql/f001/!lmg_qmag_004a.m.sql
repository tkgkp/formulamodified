:!UTF-8
select
0 as LP,
DK_C.WAR01 KJx,
ND.SYM "Symbol dokumentu",
KH.NAZ Kontrahent,
ND.D "Data dokumnetu",
ND.DA "Data akceptacji",
ND.TA "Czas akceptacji",
ND.O "Opis",
KK.SYM as Symbol_Konta,
KK.NAZWA as Nazwa_Konta,
M.KTM Kod,
M.N Nazwa,
sum(DK.IL) Ilość,
JM.KOD Jm,
DK_C.WAR02 "Partia dostawcy",
DK_L.TW "Termin ważności"
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join KK using (ND.KK,KK.REFERENCE) 
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join KH using (ND.KH, KH.REFERENCE)
   left join JM using (M.J,JM.REFERENCE)
   left join DK_C using(DK.DK_C,DK_C.REFERENCE)
   left join @DK_L using(DK_L.DK,DK.REFERENCE)
where  MG.SYM=':_a' and TYPYDOK.T like case when ':_b'='' then ':_b%' else ':_b' end and ND.D between to_date(:_c) and to_date(:_d) and ND.Z='T' 
group by DK_C.WAR01,ND.SYM,M.KTM,M.N,ND.D,ND.DA,ND.TA,ND.O,KK.SYM,KK.NAZWA,KH.NAZ,DK_C.WAR02,DK_L.TW,JM.KOD
order by 2