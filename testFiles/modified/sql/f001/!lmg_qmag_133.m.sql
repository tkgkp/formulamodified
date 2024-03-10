:!UTF-8
select 
0 as LP,
M.KTM Kod,
M.N Nazwa,
sum(case when TYPYDOK.T='RWZL' then DK.IL else 0 end) RWZL,
sum(case when TYPYDOK.T='RWZL' then DK.WAR else 0 end) RWZL_WAR,
sum(case when TYPYDOK.T='RWPZL' then DK.IL else 0 end) RWPZL,
sum(case when TYPYDOK.T='RWPZL' then DK.WAR else 0 end) RWPZL_WAR,
sum(case when TYPYDOK.T='RWP' then DK.IL else 0 end) RWP,
sum(case when TYPYDOK.T='RWP' then DK.WAR else 0 end) RWP_WAR,
sum(case when TYPYDOK.T='RWL' then DK.IL else 0 end) RWL,
sum(case when TYPYDOK.T='RWL' then DK.WAR else 0 end) RWL_WAR,
sum(case when TYPYDOK.T='RWZ' then DK.IL else 0 end) RWZ,
sum(case when TYPYDOK.T='RWZ' then DK.WAR else 0 end) RWZ_WAR,
sum(case when TYPYDOK.T='RWB' then DK.IL else 0 end) RWB,
sum(case when TYPYDOK.T='RWB' then DK.WAR else 0 end) RWB_WAR,
sum(case when TYPYDOK.T='RW' then DK.IL else 0 end) RW,
sum(case when TYPYDOK.T='RW' then DK.WAR else 0 end) RW_WAR,
sum(case when TYPYDOK.T='ZWZL' then DK.IL else 0 end) ZWZL,
sum(case when TYPYDOK.T='ZWZL' then DK.WAR else 0 end) ZWZL_WAR,
sum(case when TYPYDOK.T='ZW' then DK.IL else 0 end) ZW,
sum(case when TYPYDOK.T='ZW' then DK.WAR else 0 end) ZW_WAR,
sum(case when TYPYDOK.T='RWZL' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWPZL' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWP' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWL' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWZ' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RWB' then DK.IL else 0 end) + sum(case when TYPYDOK.T='RW' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZWZL' then DK.IL else 0 end) - sum(case when TYPYDOK.T='ZW' then DK.IL else 0 end) "ZUŻYCIE",
sum(case when TYPYDOK.T='RWZL' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWPZL' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWP' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWL' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWZ' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RWB' then DK.WAR else 0 end) + sum(case when TYPYDOK.T='RW' then DK.WAR else 0 end) - sum(case when TYPYDOK.T='ZWZL' then DK.WAR else 0 end) - sum(case when TYPYDOK.T='ZW' then DK.WAR else 0 end) "ZUŻYCIE_WARTOSCIOWO"
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join MG using (ND.MAG,MG.REFERENCE)
where 
MG.SYM IN VALUES ('SUR'), ('SUR2'), ('MMO'), ('MSU'), ('XSUR1'), ('XSUR2') and ( TYPYDOK.T='RWZL' or TYPYDOK.T='RWPZL' or TYPYDOK.T='RWP' or TYPYDOK.T='RWL' or TYPYDOK.T='RWZ'  or TYPYDOK.T='RWB'  or TYPYDOK.T='RW' or TYPYDOK.T='ZWZL'  or TYPYDOK.T='ZWZL' ) and ND.D between to_date(:_b) and to_date(:_c) and ND.Z='T' 
group by M.KTM, M.N