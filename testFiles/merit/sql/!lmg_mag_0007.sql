:!UTF-8
/*
stany magazynowe dla materialw z sumami dla grup na podany dzień
wywolywane z mag_0008.sql
_a - magazyn
_b - data
*/
select
      0 as LP,
      MGR.KOD grupa,
      '^< s u m a >' as ktm,
      '' as jedn,
      sum(DK.IL) ilosc,
      sum(DK.WAR) wartosc,
      '' as jedn2,
      sum(DK.IL2) ilosc2
from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D<= to_date(:_b)

group by MGR.KOD, M.KTM, M.N

UNION ALL
select
      0 as LP,
      MGR.KOD grupa,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      sum(DK.IL) ilosc,
      sum(DK.WAR) wartosc,
      J2.KOD as jedn2,
      sum(DK.IL2) ilosc2
from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      left join JM J2 using (M.J2, J2.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D<= to_date(:_b)

group by MGR.KOD, M.KTM, M.N, JM.KOD, J2.KOD


UNION ALL
select
      0 as LP,
      MGR.KOD grupa,
      '^< s u m a >' as ktm,
      '' as jedn,
      sum(-DK.IL) ilosc,
      sum(-DK.WAR) wartosc,
      '' as jedn2,
      sum(-DK.IL2) ilosc2
from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D<= to_date(:_b)

group by MGR.KOD, M.KTM, M.N


UNION ALL
select
      0 as LP,
      MGR.KOD grupa,
      M.KTM||' - '||M.N as ktm,
      JM.KOD as jedn,
      sum(-DK.IL) ilosc,
      sum(-DK.WAR) wartosc,
      J2.KOD as jedn2,
      sum(-DK.IL2) ilosc2
from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join JM using (M.J, JM.REFERENCE)
      left join JM J2 using (M.J2, J2.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D<= to_date(:_b)

group by MGR.KOD, M.KTM, M.N, JM.KOD, J2.KOD

order by 2
