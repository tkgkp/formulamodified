:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
M.WN,
M.WB,
case when M_OPAKOW.M is null then 'BRAK DANYCH'
else
M2.KTM
end Opakowanie,
case when M_OPAKOW.M is null then ' '
else
M2.N
end Nazwa,
M_OPAKOW.POJ 
from SM
   join M using(SM.M, M.REFERENCE)
   join MG using (SM.MAG, MG.REFERENCE)
   left join M_OPAKOW using(SM.M, M_OPAKOW.M) 
   left join M as M2 using(M_OPAKOW.OPAKOW, M2.REFERENCE)
where MG.SYM=':_a'  and M.A='T'
order by 2,4