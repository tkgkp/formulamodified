:!UTF-8
select
      0 as LP,
      KOD MatGrupaKod, 
      NAZWA MatGrupaNaz,
      sum(war_pocz) WarPocz,
      sum(przychod) as Przychod,
      sum(rozchod) as Rozchod,
      (sum(war_pocz)+sum(przychod)-sum(rozchod)) Stan

from  :_a 

group by KOD, NAZWA

