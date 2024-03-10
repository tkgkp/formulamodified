:!UTF-8
/*
  Pobrania dla surowców dla zleceń w podanym stanie
  Przetwarzane są wszystkie rekordy ze wszystkich masek tabeli DK

  Parametry: _a - stan zlecenia (N,O,Z,* - wszystkie),
             _b - grupa towarowa (* - wszystkie),
*/

select
 0 as LP,
 M.KTM as KTM,
 M.N as Nazwa,
 sum(case when DK.PLUS='N' then DK.IL else 0 end) as Pobrano,
 sum(case when DK.PLUS='T' then DK.IL else 0 end) as Zwrócono

from @DK
 join M using(DK.M,M.REFERENCE)
  join MGR using(M.MGR,MGR.REFERENCE)
 join ZL using(DK.ZL,ZL.REFERENCE)
 join @ND using(DK.N,ND.REFERENCE)
  join TYPYDOK
where
 (ZL.STAN like UPPER(':_a'))
  and (MGR.KOD like ':_b')
  and TYPYDOK.WYR='N'

group by M.KTM, M.N

