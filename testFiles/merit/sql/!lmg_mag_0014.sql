:!UTF-8
select
   0 as LP,
   DK_L.TW TermWazno,
   EANL.KOD Lok,
   M.KTM MatIndeks,
   M.N MatNaz,
   JM.KOD jm,
   sum(DK_L.IL) Ilosc,
   J2.KOD jm2,
   case
     when J2.KOD<>'' then sum(DK_L.IL2)
     else 0
   end Ilosc2
from
   @DK_L
   join M using (DK_L.M,M.reference)
   left join EANL using (DK_L.LOK,EANL.reference)
   join JM using (M.J,JM.reference)
   left join JM J2 using (M.J2,J2.reference)
where
   DK_L.Z='T'
   and DK_L.MG=:_a
   and DK_L.TW<=to_date(:_b)

group by
   0,DK_L.TW,EANL.KOD,M.KTM,M.N,JM.KOD,J2.KOD

having
   sum(DK_L.IL)<>0

union all

select
   0 as LP,
   SC.TW TermWazno,
   MG.SYM Lok,
   M.KTM MatIndeks,
   M.N MatNaz,
   JM.KOD jm,
   sum(SC.S) Ilosc,
   J2.KOD jm2,
   case
     when J2.KOD<>'' then sum(SC.S2)
     else 0
   end Ilosc2

from
   @SC
   join M using (SC.M,M.reference)
   join MG using (SC.MAG,MG.reference)
   join JM using (M.J,JM.reference)
   left join JM J2 using (M.J2,J2.reference)
where
   MG.SL='N'
   and MG.REFERENCE=:_a
   and SC.TW<=to_date(:_b)
   and M.SETW='P'

group by
   0,SC.TW,MG.SYM,M.KTM,M.N,JM.KOD,J2.KOD

having
   sum(SC.S)<>0

order by
   2,3,4

