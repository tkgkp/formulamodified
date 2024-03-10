:!UTF-8
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      sum(DK.WAR) war_pocz,
      0 as Przychod,
      0 as rozchod

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D< to_date(:_b)

group by MGR.KOD, MGR.NAZ


UNION ALL
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      sum(-DK.WAR) war_pocz,
      0 as Przychod,
      0 as rozchod

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D< to_date(:_b)

group by MGR.KOD, MGR.NAZ


UNION ALL
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      0 as war_pocz,
      sum(DK.WAR) Przychod,
      0 as rozchod

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and extract(year from ND.D) = extract(year from to_date(:_b))
  and extract(month from ND.D) = extract(month from to_date(:_b))

group by MGR.KOD, MGR.NAZ


UNION ALL
select
      0 as LP,
      MGR.KOD KOD,
      MGR.NAZ NAZWA,
      0 as war_pocz,
      0 as Przychod,
      sum(DK.WAR) rozchod

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      left join MGR using (M.MGR, MGR.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and extract(year from ND.D) = extract(year from to_date(:_b))
  and extract(month from ND.D) = extract(month from to_date(:_b))

group by MGR.KOD, MGR.NAZ


order by 2
