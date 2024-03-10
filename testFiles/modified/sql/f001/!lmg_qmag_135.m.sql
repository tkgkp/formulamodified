:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(case when TYPYDOK.T='PZ' then DK.IL else 0 end)+sum(case when TYPYDOK.T='IMP' then DK.IL else 0 end)+sum(case when TYPYDOK.T='WNT' then DK.IL else 0 end) "Przychód zewnętrzny",
JM.KOD Jm
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join JM using (M.J,JM.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where 
MG.SYM IN VALUES ('SUR'), ('SUR2'), ('XSUR1'), ('XSUR2') and ( TYPYDOK.T='PZ' or TYPYDOK.T='IMP' or TYPYDOK.T='WNT') and ND.D between to_date(:_b) and to_date(:_c) and ND.Z='T' 
group by M.KTM, M.N, JM.KOD
Order by Kod