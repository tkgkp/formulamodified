:!UTF-8
select                                                                        
      0 as LP,                                                                     
      POJAZDY.NRREJ nr_rej,
      M.N dodatek,
      sum(SAMDOD.IL) ilosc,
      JM.KOD jedn,
      sum(SAMDOD.WAR) wartosc

from  SAMDOD                                                                     
      join SAMK using (SAMDOD.SAMK, SAMK.REFERENCE)       
      left join M using (SAMDOD.M, M.REFERENCE)
      join POJAZDY using (SAMK.POJAZD, POJAZDY.REFERENCE)
      left join JM using (SAMDOD.JM, JM.REFERENCE)

where SAMK.D>= to_date(:_a)
  and SAMK.D<= to_date(:_b)
  and POJAZDY.FIRMA = :_c
                                                                             
group by POJAZDY.NRREJ,M.N,JM.KOD
order by 2