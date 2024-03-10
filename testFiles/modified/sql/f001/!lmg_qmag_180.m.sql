:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='01' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='01' then DK.IL else 0  end) miesiac_01,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='02' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='02' then DK.IL else 0  end) miesiac_02,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='03' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='03' then DK.IL else 0  end) miesiac_03,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='04' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='04' then DK.IL else 0  end) miesiac_04,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='05' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='05' then DK.IL else 0  end) miesiac_05,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='06' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='06' then DK.IL else 0  end) miesiac_06,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='07' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='07' then DK.IL else 0  end) miesiac_07,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='08' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='08' then DK.IL else 0  end) miesiac_08,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='09' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='09' then DK.IL else 0  end) miesiac_09,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='10' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='10' then DK.IL else 0  end) miesiac_10,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='11' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='11' then DK.IL else 0  end) miesiac_11,
sum(case when TYPYDOK.T='RWZL' and substr(to_string(ND.D),6,2)='12' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL'  and substr(to_string(ND.D),6,2)='12' then DK.IL else 0  end) miesiac_12
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where (MG.SYM=':_a'  or ':_a'='') and  substr(to_string(ND.D),1,4)=':_b'  and ND.Z='T' and  M.KTM like '%:_c%'
group by M.KTM, M.N
