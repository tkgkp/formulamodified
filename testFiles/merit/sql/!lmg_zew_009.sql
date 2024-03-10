:!UTF-8
/*
 Zamówienia materiałów:
 Parametry: _a - wyrób, półfabrykat, surowiec (W,P,S,H,* - wszystkie materiały)
*/

select
 0 as LP,
 M.KTM as Towar,
 M.N as Nazwa,
 sum(ZK_P.ILZ) as Zamówiono,
 sum(ZK_P.ILRB) as Zarezerwowano,
 sum(ZK_P.ILP) as Pozostało
from ZK_P
 join ZK_N
 join M using (ZK_P.M, M.REFERENCE)
where 
 ZK_N.STAT_REJ<>'A'
 and ZK_P.RODZ='W' 
 and ZK_P.N is not NULL
 and (M.R like UPPER(':_a'))
group by M.KTM, M.N
order by Towar


