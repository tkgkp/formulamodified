:!UTF-8
select
   0 as LP,
   EANL.KOD EAN,
   M.KTM MatIndeks,
   sum(DK_L.IL) Ilosc,
   JM.KOD jm,
   case
     when J2.KOD<>'' then sum(DK_L.IL2)
     else 0
   end Ilosc2,
   J2.KOD jm2
from
   @DK_L
   join M using(DK_L.M,M.reference)
   join JM using(M.J,JM.reference)
   left join JM J2 using(M.J2,J2.reference)
   join EANL using (DK_L.LOK,EANL.reference)
where
   DK_L.Z='T'
   and DK_L.MG = ':_a'
   and DK_L.DT <= to_date(:_b)
   and (DK_L.DK is not null or DK_L.DK_LN is not null)
group by
   0,EANL.KOD,M.KTM,JM.KOD,J2.KOD

