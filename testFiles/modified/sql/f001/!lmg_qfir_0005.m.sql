:!UTF-8
/*
stany magazynowe dla materialw z sumami dla grup na podany dzien
wywolywane z fir_0004.sql
_a - magazyny
_b - data
*/
select
      0 as LP,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      '^< s u m a >' as mg,
      max(cast(null as DATE_TYPE)) as OST_OPER,
      sum(DK.IL) ilosc,
      sum(DK.WAR) wartosc

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D<= to_date(:_b)
  and :_a

group by M.KTM, M.N, JM.KOD

UNION ALL
select
      0 as LP,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      MG.SYM mg,
      max(case when TYPYDOK.DN<>'T' and TYPYDOK.DK='N' then ND.D else cast(null as DATE_TYPE) end) as OST_OPER,
      sum(DK.IL) ilosc,
      sum(DK.WAR) wartosc

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D<= to_date(:_b)
  and :_a

group by M.KTM, M.N, JM.KOD, MG.SYM


UNION ALL
select
      0 as LP,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      '^< s u m a >' as mg,
      max(cast(null as DATE_TYPE)) as OST_OPER,
      sum(-DK.IL) ilosc,
      sum(-DK.WAR) wartosc

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D<= to_date(:_b)
  and :_a

group by M.KTM, M.N, JM.KOD


UNION ALL
select
      0 as LP,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      MG.SYM mg,
      max(case when TYPYDOK.DN<>'T' and TYPYDOK.DK='N' then ND.D else cast(null as DATE_TYPE) end) as OST_OPER,
      sum(-DK.IL) ilosc,
      sum(-DK.WAR) wartosc

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      join TYPYDOK using (ND.TYP,TYPYDOK.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D<= to_date(:_b)
  and :_a

group by M.KTM, M.N, JM.KOD, MG.SYM

order by 2