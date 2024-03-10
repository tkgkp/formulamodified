:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(DK.IL) Ilość,
sum(DK.WAR) Wartość
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where MG.SYM=':_a' and TYPYDOK.T=':_b' and ND.D between to_date(:_c) and to_date(:_d) and ND.Z='T' 
group by M.KTM,M.N
order by 2,3
