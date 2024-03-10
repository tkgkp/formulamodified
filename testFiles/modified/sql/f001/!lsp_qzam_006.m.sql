:!UTF-8
select
   0 LP,HAN.NAZ,KH.NAZ,ZK_N.SYM, ZK_N.DT TERMIN,((sum(ZK_P.ILZ)-sum(ZK_P.ILP))/sum(ZK_P.ILZ))*100 PROCENT
from
   @ZK_P
   left join @ZK_N using (ZK_P.N,ZK_N.REFERENCE)
   left join HAN using (ZK_N.HAN,HAN.REFERENCE)
   left join KH using (ZK_N.KH,KH.REFERENCE)
   left join TYPYZAM using (ZK_N.T,TYPYZAM.REFERENCE)
where
   ZK_N.DT<to_date(:_a) and TYPYZAM.R='Z' and ZK_N.SYM not like '%OF%'
group by
   HAN.NAZ,KH.NAZ,ZK_N.SYM,ZK_N.DT
order by
   2,3