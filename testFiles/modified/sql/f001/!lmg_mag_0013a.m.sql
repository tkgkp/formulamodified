:!UTF-8
select
   0 as LP,
   ND.Z as DokAkc,
   MG.SYM as MagSymbol,
   TYPYDOK.T as DokTyp,
   ND.SYM as DokSymbol,
   to_string(ND.D) as DokData,
   KH.SKR as KontrSkr,
   MGR.KOD as MatGrupaKod,
   M.KTM as MatIndeks,
   M.N as Nazwa,
   ND.O as Opis,
   DK.IL as Ilosc,
   JM.KOD as Jm,
   DK.C as Cena,
   DK.WAR as WarMag,
   FAKS.SYM as DokSpSymbol,
   DK.WN as Netto,
   case
     when J2.KOD<>'' then DK.IL2
     else 0
   end as Ilosc2,
   J2.KOD as Jm2,
   KK.SYM as Symbol_Konta,
   KK.NAZWA as Nazwa_Konta,
   USERS.KOD as Operator
from
   @DK
   join M using (DK.M,M.REFERENCE)
   left join MGR using (M.MGR,MGR.REFERENCE)
   join JM using (M.J,JM.REFERENCE)
   left join JM J2 using (M.J2,J2.REFERENCE)
   join @ND using (DK.N,ND.REFERENCE)
   join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   left join KK using (ND.KK, KK.REFERENCE)
   join MG using (ND.MAG,MG.REFERENCE)
   left join USERS using (ND.US,USERS.REFERENCE)
   left join KH using (ND.KH,KH.REFERENCE)
   left join @FAKS using (ND.FAKS,FAKS.REFERENCE)
where
   DK.PLUS='N'
   and ((ND.D between to_date(:_a) and to_date(:_b)) or (to_date(:_a) is null and to_date(:_b) is null))
   and :_c
   and :_d
   and :_e
   and :_f
   and :_g
   and :_h
   and :_i
order by 3,4,5,6,8,9