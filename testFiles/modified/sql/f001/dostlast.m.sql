:!UTF-8
select 0 as LP,
          M.KTM,
          M.N,
          ND.D,
          DK.C,
          ND.SYM,
          SLO.REFERENCE as REF,
          DK.CWAL,
          DK.REFERENCE as DK_REF,
          ND.REFERENCE as ND_REF,
          CASE
	WHEN ( TYPYDOK.T='PZ'  or TYPYDOK.T='WNT' or TYPYDOK.T='IMP' ) AND ND.D > to_date('2021/07/31') THEN 1
	ELSE 0
          END as FAPMOZE
from @DK
   left join M using (DK.M,M.REFERENCE)
   left join SLO using (DK.WAL,SLO.REFERENCE)
   left join @ND using (DK.N,ND.REFERENCE)
   left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
where ND.Z='T' and ( TYPYDOK.T='PZ'  or TYPYDOK.T='WNT' or TYPYDOK.T='IMP' or TYPYDOK.T='KRC+' or TYPYDOK.T='BO' or TYPYDOK.T='BM' or TYPYDOK.T='MBO') and
      ND.D>=to_date(:_a) and ND.D<=to_date(:_b) and ( ND.MAG=:_c ) and
      (DK.C <> 0 or DK.CWAL <> 0)
order by 2,4

