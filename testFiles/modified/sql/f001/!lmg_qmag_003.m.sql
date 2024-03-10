:!UTF-8
select 
0 as LP,
SC.WAR01 KJx,
ND.SYM "Symbol dokumentu",
KH.NAZ Kontrahent,
ND.D "Data dokumnetu",
ND.DA "Data akceptacji",
ND.TA "Czas akceptacji",
M.KTM Kod,
M.N Nazwa,
sum(DK.IL) Ilość,
JM.KOD Jm,
SC.WAR02 "Partia dostawcy",
DK_L.TW "Termin ważności"
from 
  @SC join 
  M join 
  MG join 
  @DK using(SC.SRDK,DK.REFERENCE) left join
  @ND using (DK.N,ND.REFERENCE) left join
  JM using (M.J,JM.REFERENCE) left join
  TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE) left join
  KH using (ND.KH,KH.REFERENCE) left join
  @DK_L using(DK_L.DK,DK.REFERENCE)
where MG.SYM=':_a' and TYPYDOK.T like case when ':_b'='' then ':_b%' else ':_b' end and ND.D between to_date(:_c) and to_date(:_d)
group by SC.WAR01,ND.SYM,M.KTM,M.N,ND.D,ND.DA,ND.TA,KH.NAZ,SC.WAR02,DK_L.TW,JM.KOD
order by 2
