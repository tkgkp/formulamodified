:!UTF-8
select 0 as LP,TYPYDOK.T Typ_dokumentu,ND.SYM Symbol , ND.D Data
from ND
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
where ND.STAT_REJ<>'T'  and ND.D>=to_date(:_b) and ND.D<=to_date(:_c) and (MG.SYM=':_a' or ':_a'='')
order by 2,3,4