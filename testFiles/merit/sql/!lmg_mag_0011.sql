:!UTF-8
select
 0 as LP,
 ND.ODDZ as Oddział,
 MG.SYM as Symbol,
 TYPYDOK.T as "Typ dokumentu",
 ND.SYM as "Symbol dokumentu",
 to_string(ND.D) as "Data dokumentu",
 KH.SKR as Kontrahent,
 MGR.KOD as "Grupa",
 M.KTM as "Indeks",
 DK.IL as "Ilość",
 JM.KOD as "jm",
 case
  when J2.KOD<>'' then DK.IL2
  else 0
 end as "Ilość 2",
 J2.KOD as "jm 2",
 DK.C as Cena,
 DK.WAR as Wartość

from
 @DK
 join @ND using (DK.N,ND.REFERENCE)
 join MG using (ND.MAG,MG.REFERENCE)
 left join M using (DK.M,M.REFERENCE)
 left join MGR using (M.MGR,MGR.REFERENCE)
 left join JM using (M.J,JM.REFERENCE)
 left join JM J2 using (M.J2,J2.REFERENCE)
 left join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
 left join KH using (ND.KH,KH.REFERENCE)

where
 ND.TRN='T'
 and ((ND.D between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
 and :_c
 and :_d
 and :_e

order by Oddział,Symbol,"Typ dokumentu","Symbol dokumentu","Data dokumentu",Kontrahent,"Indeks","Ilość"

