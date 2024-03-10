:!UTF-8
select 
 0 as LP,
 USERS.DANE,
 ND.D, 
 MG.SYM,
 TYPYDOK.T,
 count(DISTINCT ND.REFERENCE) Dokumentów,
 count(DISTINCT DK.REFERENCE) Pozycji
from @DK
   left join @ND using (DK.N,ND.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join USERS using (ND.US,USERS.REFERENCE) 
where ND.D>to_date(:_a) and ND.D<=to_date(:_b) and ND.Z='T' and ( USERS.DANE like '%:_c%' or ':_c'='')
group by USERS.DANE,ND.D, MG.SYM,TYPYDOK.T
order by 2,3,4,5
