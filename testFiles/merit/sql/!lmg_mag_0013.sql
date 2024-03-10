:!UTF-8
select
   0 as LP,
   ND.Z as DokAkc,
   ND.ODDZ as Oddz,
   MG.SYM as MagSymbol,
   TYPYDOK.T as DokTyp,
   ND.SYM as DokSymbol,
   to_string(ND.D) as DokData,
   KH.SKR as KontrSkr,
   to_string(DK.P) as DokPoz,
   MGR.KOD as MatGrupaKod,
   M.KTM as MatUslIndeks,
   DK.IL as Ilosc,
   JM.KOD as Jm,
      case
     when J2.KOD<>'' then DK.IL2
     else 0
   end as Ilosc2,
   J2.KOD as Jm2,
   DK.C as Cena,
   DK.WAR as WarMag,
   FAKS.SYM as DokSpSymbol,
   DK.WN as Netto,
   USERS.KOD as Operator
from
   @DK
   join M using (DK.M,M.REFERENCE)
   left join MGR using (M.MGR,MGR.REFERENCE)
   join JM using (M.J,JM.REFERENCE)
   left join JM J2 using (M.J2,J2.REFERENCE)
   join @ND using (DK.N,ND.REFERENCE)
   join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   join MG using (ND.MAG,MG.REFERENCE)
   left join USERS using (ND.US,USERS.REFERENCE)
   left join KH using (ND.KH,KH.REFERENCE)
   left join @FAKS using (ND.FAKS,FAKS.REFERENCE)
   join USERS_UP using(USERS_UP.MG,ND.MAG)
where
   DK.PLUS='N'
   and USERS_UP.AKR='MG' and USERS_UP.USERS=:_j
   and ((ND.D between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
   and :_c
   and :_d
   and :_e
   and :_f
   and :_g
   and :_h
   and :_i
order by 2,3,4,5,6,8

