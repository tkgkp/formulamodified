:!UTF-8
select 
0 as LP,
M.KTM,
M.N,
SUM(SC.S) Stan,
SC.WAR02 Partia,
SC.WAR01 KJx,
DK_L.TW,
EANL.KOD Lok  
from 
  @SC join 
  M join 
  MG join 
  @DK using(SC.SRDK,DK.REFERENCE) left join
  @DK_L using(DK_L.DK,DK.REFERENCE) join
  @EANL using(DK_L.LOK,EANL.REFERENCE)
where SC.S <> 0 AND MG.SYM = ':_a'
group by M.KTM,M.N,SC.WAR02,SC.WAR01,DK_L.TW,EANL.KOD
order by 2