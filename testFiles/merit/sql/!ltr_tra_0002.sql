:!UTF-8
select 
      0 as LP,
      POJAZDY.NRREJ samochod,
      NWYR.NAZ Zlecenie,
      sum(KM) km
from @SAMKOSZ
        join NWYR using (SAMKOSZ.NWYR, NWYR.REFERENCE)
        join SAMK using (SAMKOSZ.SAMK, SAMK.REFERENCE)
        join POJAZDY using (SAMK.POJAZD, POJAZDY.REFERENCE)

where (POJAZDY.FIRMA=:_a)
  and (SAMK.D between to_date(:_b) and to_date(:_c) or SAMK.D is null) 
  and (POJAZDY.NRREJ =':_d' or ':_d' ='' )

group by POJAZDY.NRREJ,NWYR.NAZ