:!UTF-8
select
   0 as LP,
   M.KTM MatUslIndeks,
   sum(FAP.IL) Ilosc,
   sum(FAP.WWAL_P) Netto,
   sum(FAP.BWAL_P) Brutto,
   JM.KOD Jm
from
   @FAP
   join @FAKS using (FAP.FAKS, FAKS.REFERENCE)
   join M using (FAP.M, M.REFERENCE)
   left join JM using (FAP.JM,JM.REFERENCE)
where
   FAKS.ODDZ = ':_a'
   and (FAKS.DW>= to_date(:_b) or to_date(:_b) is null)
   and (FAKS.DW<= to_date(:_c) or to_date(:_c) is null)
   and :_d
   and (M.RODZ =':_e' or ':_e'='')
   and FAKS.SZ='S'
   and FAKS.ZEST='T' and FAKS.ZEST_AKC='T' and FAKS.STAT_REJ<>'A'
   and :_f
group by
   M.KTM, JM.KOD
order by
   2

--Sign Version 2.0 jowisz:1045 2023/08/23 14:35:05 107d7507991e0577dc66b52e0c33bf9961d175cfcfa95b9ab7c746ee90e56cba1715fd574d3e3609e17094abea77ced333cb002a69f68510eab94379c062cf15d6060108dac314c53e9ac839bea81687c2d2f3daefb23a3eff0878ad150d2aa21d916ad94348463677f0a6600e56cc91453266ec2883f602a3ecf711e2ffcc32
