:!UTF-8
/*
 Zamówienia materiałów:
 Parametry: _a - wyrób, półfabrykat, surowiec (W,P,S,T,* - wszystkie materiały)
*/

select
   0 as LP,
   M.KTM as Towar,
   M.N as Nazwa,
   ZK_P.ILZ as Zamówiono,
   ZK_P.ILRB as Zarezerwowano,
   ZK_P.ILP as Pozostało,
   to_string(ZK_N.DT) as Realizacja
from ZK_P
   join ZK_N
   join M using (ZK_P.M, M.REFERENCE)
where 
 ZK_N.STAT_REJ<>'A'
 and ZK_P.RODZ='W' 
 and ZK_P.N is not NULL 
 and (M.R like UPPER(':_a'))
order by Towar


