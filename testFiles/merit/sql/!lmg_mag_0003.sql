:!UTF-8
/*
stany magazynowe dla grup na podany dzień
wywolywane z mag_0004.sql
_a - magazyn
_b - data
*/
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      sum(DK.WAR) WARTOSC

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

group by MGR.KOD, MGR.NAZ


UNION ALL
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      sum(-DK.WAR) WARTOSC

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

group by MGR.KOD, MGR.NAZ


order by 2
