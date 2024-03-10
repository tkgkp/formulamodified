:!UTF-8
select
   0 LP,
   MG.SYM MagSymbol,
   TYPYDOK.T DokTyp,
   ND.NR DokNr,
   ND.SYM DokSymbol,
   ND.AM DokMiesiac,
   ND.Z DokAkc,
   ND.D DokData,
   DK.P DokPoz,
   M.KTM MatIndeks,
   M.N MatNazwa,
   MGR.NAZ GrpNazwa,
   DK.IL,
   round(DK.C,4) Cena,
   DK.WAR
from
   @DK
   join M using (DK.M,M.reference)
   join MGR using (M.MGR,MGR.reference)
   join @ND using (DK.N,ND.reference)
   join MG using (ND.MAG,MG.reference)
   join TYPYDOK using (ND.TYP,TYPYDOK.reference)
where
   ND.D<=to_date(:_a)
   and MG.SYM like case when ':_b'='' then '%' else ':_b' end
   and ND.Z='T'
   and (DK.WAR=0
 and DK.C=0)
   and M.RODZ='T'
order by
   2,3,4,9
