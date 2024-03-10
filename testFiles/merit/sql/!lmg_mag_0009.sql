:!UTF-8
/*
*/
select
      0 as LP,
      TYPYDOK.T typ,
      sum(DK.WAR) war_pocz,
      0 as Przychod,
      0 as rozchod,
      substr (:_b,1,7) popokr

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join TYPYDOK using (ND.TYP, TYPYDOK.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and ND.D < to_date((extract(year from to_date(:_b))||'-'||extract(month from to_date(:_b)) ||'-1'))

group by TYPYDOK.T

UNION ALL

select
      0 as LP,
      TYPYDOK.T typ,
      sum(-DK.WAR) war_pocz,
      0 as Przychod,
      0 as rozchod,
      substr (:_b,1,7) popokr

from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join TYPYDOK using (ND.TYP, TYPYDOK.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and ND.D < to_date((extract(year from to_date(:_b))||'-'||extract(month from to_date(:_b)) ||'-1'))

group by TYPYDOK.T

UNION ALL

select
      0 as LP,
      TYPYDOK.T typ,
      0 as war_pocz,
      sum(DK.WAR) Przychod,
      0 as rozchod,
      substr (:_b,1,7) popokr


from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join TYPYDOK using (ND.TYP, TYPYDOK.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='T'
  and extract(year from ND.D) = extract(year from to_date (:_b))
  and extract(month from ND.D) = extract(month from to_date (:_b))

group by TYPYDOK.T


UNION ALL
select
      0 as LP,
      TYPYDOK.T typ,
      0 as war_pocz,
      0 as Przychod,
      sum(DK.WAR) rozchod,
      substr (:_b,1,7) popokr


from  @DK
      join @ND using (DK.N, ND.REFERENCE)
      join MG using (ND.MAG, MG.REFERENCE)
      join M using (DK.M, M.REFERENCE)
      join TYPYDOK using (ND.TYP, TYPYDOK.REFERENCE)

where MG.SYM = ':_a'
  and M.RODZ = 'T'
  and ND.Z = 'T'
  and DK.PLUS='N'
  and extract(year from ND.D) = extract(year from to_date (:_b))
  and extract(month from ND.D) = extract(month from to_date (:_b))

group by TYPYDOK.T
