:!UTF-8
select 
0 as LP,
M.KTM||' '||M.N as "Towar",
KH.NAZ as "Kontrahent",
ND.D as "Data dokumentu",
ND.SYM as "Symbol dokumentu",
DK.IL as "Ilość"
from
@DK
left join @ND using (DK.N,ND.reference)
left join M using (DK.M,M.reference)
left join MG using (ND.MAG,MG.reference)
left join KH using (ND.KH,KH.reference)
where
DK.PLUS='N' and
MG.SYM=':_c' and
DK.RDK in (select DK_HS.RDK from @DK_HS left join @BADH where BADH.WYNIK='N' and DK_HS.KIND='L' and (DK_HS.DT>=to_date(:_a) and DK_HS.DT<=to_date(:_b)))
order by 
1,2,3
