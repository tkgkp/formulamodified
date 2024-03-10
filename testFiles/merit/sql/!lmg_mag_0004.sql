:!UTF-8
select
      0 as LP,
      KOD MatGrupaKod, 
      NAZWA MatGrupaNaz,
      sum(WARTOSC) WarMag

from  :_b

group by KOD, NAZWA

