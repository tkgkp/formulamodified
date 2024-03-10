:!UTF-8
select 0 as LP, KH.NAZ Klient, HAN.NAZ Handlowiec ,ZK_N.SYM,ZK_N.DP Data,ZK_N.DT Termin,M.KTM,M.N Nazwa,ZK_P.ILP Ilosc, ZK_P.CENA
from ZK_P
   left join ZK_N using (ZK_P.N,ZK_N.REFERENCE)
   left join KH using (ZK_N.KH,KH.REFERENCE)
   left join HAN using (ZK_N.HAN,HAN.REFERENCE)
   left join M using (ZK_P.M,M.REFERENCE) 
where ZK_P.ILP>0 and ZK_N.DT<to_date(:_a)
           and ZK_P.TOP = 1 and ZK_P.A = 'A'
order by 2