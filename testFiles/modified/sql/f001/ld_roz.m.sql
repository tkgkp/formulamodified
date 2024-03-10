:!UTF-8
select 0 as LP,
          M.KTM,
          M.N,
          ND.D,
          DK.IL as IL_ROZ,
          DK.C,
          ND.SYM,
          SLO.REFERENCE as REF,
          DK.CWAL,
          DK.REFERENCE as DK_REF,
          ND.REFERENCE as ND_REF
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join SLO using (DK.WAL,SLO.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
where ND.Z='T' and ( TYPYDOK.T='RW'  or TYPYDOK.T='RWZL' or TYPYDOK.T='RWZ' or TYPYDOK.T='RWB' or TYPYDOK.T='RWL') and
      ND.D>=to_date('2009/09/01') and ND.D<=to_date(:_a) and
      (DK.C <> 0 or DK.CWAL <> 0)
order by 2,4

