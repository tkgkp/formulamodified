:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(case when TYPYDOK.T='RWZL' then DK.IL else 0 end) RW,
sum(case when TYPYDOK.T='RWL' then DK.IL else 0 end) RWL,
sum(case when TYPYDOK.T='RWZ' then DK.IL else 0 end) RWZ,
sum(case when TYPYDOK.T='RWP' then DK.IL else 0 end) RWP,
sum(case when TYPYDOK.T='ZWZL' then DK.IL else 0 end) ZW,
sum(case when TYPYDOK.T='PZ' then DK.IL else 0 end) PZ
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where 
substr(MG.SYM,1,3)='MAP' and ( TYPYDOK.T='RWZL' or TYPYDOK.T='RWL' or TYPYDOK.T='RWZ' or TYPYDOK.T='RWP' or TYPYDOK.T='ZWZL' or TYPYDOK.T='PZ' ) and ND.D between to_date(:_b) and to_date(:_c) and ND.Z='T' 
group by M.KTM, M.N