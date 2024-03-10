:!UTF-8
select
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(case when TYPYDOK.T='PZ' then DK.IL else 0 end) PZ,
sum(case when TYPYDOK.T='PZ' then (DK.WAR) else 0 end) "Wartość PZ",
sum(case when TYPYDOK.T='PW' then DK.IL else 0 end) PW,
sum(case when TYPYDOK.T='PW' then (DK.WAR) else 0 end) "Wartość PW",
sum(case when TYPYDOK.T='RWKM' then DK.IL else 0 end) RWKM,
sum(case when TYPYDOK.T='RWKM' then (DK.WAR) else 0 end) "Wartość RWKM",
sum(case when TYPYDOK.T='PW' then DK.IL else 0 end) - sum(case when TYPYDOK.T='RWKM' then DK.IL else 0 end) "PW po korekcie",
sum(case when TYPYDOK.T='PW' then (DK.WAR) else 0 end) - sum(case when TYPYDOK.T='RWKM' then (DK.WAR) else 0 end) "Wartość PW po korekcie",
sum(case when TYPYDOK.T='RWZL' then DK.IL else 0 end) RWZL,
sum(case when TYPYDOK.T='RWZL' then (DK.WAR) else 0 end) "Wartość RWZL",
sum(case when TYPYDOK.T='RWL' then DK.IL else 0 end) RWL,
sum(case when TYPYDOK.T='RWL' then (DK.WAR) else 0 end) "Wartość RWL",
sum(case when TYPYDOK.T='RWZ' then DK.IL else 0 end) RWZ,
sum(case when TYPYDOK.T='RWZ' then (DK.WAR) else 0 end) "Wartość RWZ",
sum(case when TYPYDOK.T='ZWZL' then DK.IL else 0 end) ZWZL,
sum(case when TYPYDOK.T='ZWZL' then (DK.WAR) else 0 end) "Wartość ZWZL",
sum(case when TYPYDOK.T='ZWM' then DK.IL else 0 end) ZWM,
sum(case when TYPYDOK.T='ZWM' then (DK.WAR) else 0 end) "Wartość ZWM",
sum(case when TYPYDOK.T='RWZL' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWL' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWZ' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL' then DK.IL else 0 end) "ZUŻYCIE",
sum(case when TYPYDOK.T='RWZL' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWL' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWZ' then DK.WAR else 0 end) - sum(case when TYPYDOK.T='ZWZL' then DK.WAR else 0 end) "ZUŻYCIE WARTOŚCIOWO",
sum(Ilosc) "Stan na początek okresu",
sum(Wartosc) "Stan na początek okresu (wartosciowo)"
from DK
   left join M using (DK.M,M.REFERENCE)
   left join ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
   left join :_d using (M.REFERENCE,Mat_Ref)
where
MG.SYM like ':_a%' and ( TYPYDOK.T='PZ' or TYPYDOK.T='PW' or TYPYDOK.T='RWZL' or TYPYDOK.T='RWL' or TYPYDOK.T='RWZ' or TYPYDOK.T='ZWZL' or TYPYDOK.T='ZWM' or TYPYDOK.T='RWKM') and ND.D between to_date(:_b) and to_date(:_c) and ND.Z='T'
group by M.KTM, M.N