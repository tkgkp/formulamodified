:!UTF-8
/* Parametry:
    _a - status zgłoszenia
*/
select
   0 as LP,
   REM_ZGL.SYM as "Symbol zgłoszenia",
   REM_ZGL.STAT_REJ as "Status zgłoszenia",
   REM_ZAS.SYMBOL as "Symbol zasobu",
   REM_KATG.SYMBOL as "Kat. zgłoszenia"
from
   REM_ZGL left join REM_ZAS left join REM_KATG
where
  (REM_ZGL.STAT_REJ in(:_a))
