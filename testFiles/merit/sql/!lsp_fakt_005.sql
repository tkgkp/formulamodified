:!UTF-8
select
   0 as LP,
   SLO.KOD as Wal,
    sum(FAKSPL.WAR) as Brutto
from
   @FAKS
   join TYPYSP using (FAKS.T, TYPYSP.REFERENCE)
   join SLO using (FAKS.WAL, SLO.REFERENCE)
   join @FAKSPL using (FAKSPL.FAKS, FAKS.REFERENCE)
where
   FAKS.ODDZ=':_c'
   and ((FAKSPL.TERMPLAT  between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
   and ((FAKS.DW between to_date(:_d) and to_date(:_e)) or (to_date(:_d) is null and to_date(:_e) is null))
   and FAKS.SZ='S'
   and FAKS.ZEST='T' and FAKS.KZ='' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
   and :_f
group by
   SLO.KOD

