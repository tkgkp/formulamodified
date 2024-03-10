:!UTF-8
/*
   Płaca zasadnicza i premia - NUCO
   Parametry:
      :_a - Lista współpracowników wg posiadanych uprawnień
      :_b - Zatrudnieni w dniu
      :_c - Tabela z danymi (wykorzystuje parametr a i b)
*/

select
   0 as "LP",
   NAZWISKO as "Nazwisko",
   PIERWSZE as "Imię",
   SYMBOL as "Kom. org.",
   STN as "Stanowisko",
   PLEC as "Płeć",
   OSOB as "Osób",
   ETAT as "Etaty",
   MSC as "Mc",
   PLACA  as "Płaca",
   PROC as "Procent",
   PREMIA as "Premia",
   RAZEM as "Razem" 
from 
   :_c
order by 
   2,3,4