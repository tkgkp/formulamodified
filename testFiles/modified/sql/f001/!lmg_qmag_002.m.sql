:!UTF-8
select
   0 as LP,
   ND.Z as Akc,
   ND.ODDZ as Oddz,
   MG.SYM as Magazyn,
   TYPYDOK.T as Typ,
   ND.SYM as Dokument,
   to_string(ND.D) as Data,
   KH.SKR as Kontrahent,
   to_string(DK.P) as Poz,
   MGR.KOD as Grupa,
   M.KTM as Indeks_tow,
   M.N as Nazwa,
   DK.IL as Ilosc,
   JM.KOD as JM,
   USERS.KOD as Operator
from
   @DK
   join M using (DK.M,M.REFERENCE)
   left join MGR using (M.MGR,MGR.REFERENCE)
   join JM using (M.J,JM.REFERENCE)
   join @ND using (DK.N,ND.REFERENCE)
   join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
   join MG using (ND.MAG,MG.REFERENCE)
   join USERS using (ND.US,USERS.REFERENCE)
   left join KH using (ND.KH,KH.REFERENCE)
   left join @FAKS using (ND.FAKS,FAKS.REFERENCE)
where
   DK.PLUS='N'
   and (ND.D between to_date(:_a) and to_date(:_b))
   and :_c
   and :_d
   and :_e
   and :_f
   and :_g
   and :_h
   and :_i
order by 2,3,4,5,6,8