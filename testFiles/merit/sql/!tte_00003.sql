:!UTF-8
/*
  Limity dla surowców dla zleceń w podanym stanie
  Przetwarzane są wszystkie rekordy ze wszystkich masek tabeli zlim????

  Parametry: _a - stan zlecenia (N,H,O,Z,* - wszystkie),
             _b - grupa towarowa (* - wszystkie),
*/

select
 0 as LP,
 M.KTM as KTM,
 M.N as Nazwa,
 MGR.KOD as Grupa,
 sum (ZLIM.LIL) as Ilość

from @ZLIM
 join M using (ZLIM.KTM, M.REFERENCE)
  join MGR using (M.MGR, MGR.REFERENCE)
   join ZL using (ZLIM.ZLEC, ZL.REFERENCE)

where  (ZL.STAN like UPPER(':_a')) and
       (MGR.KOD like ':_b')

group by MGR.KOD, M.KTM, M.N

order by KTM


