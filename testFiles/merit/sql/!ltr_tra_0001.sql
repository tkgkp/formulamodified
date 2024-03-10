:!UTF-8
select                                                                        
      0 as LP,                                                                     
      POJAZDY.NRREJ nr_rej,
      SAMK.SYM nr_karty,
      SAMDOD.NAZ nazwa,
      SAMDOD.IL ilosc,
      JM.KOD jedn,
      SAMDOD.WAR wartosc

from  SAMDOD                                                                     
      join SAMK using (SAMDOD.SAMK, SAMK.REFERENCE)       
      join POJAZDY using (SAMK.POJAZD, POJAZDY.REFERENCE)
      left join JM using (SAMDOD.JM, JM.REFERENCE)

where SAMK.D>= to_date(:_a)
  and SAMK.D<= to_date(:_b)
  and POJAZDY.FIRMA = :_c
                                                                              
order by 2,3 