:!UTF-8
/* Parametry:
    _a - status zgłoszenia
    _b - symbol zasobu
    _c - data awarii od (może być 0000/00/00, wtedy od dowolnej daty)
    _d - data awarii do (może być 0000/00/00, wtedy do dowonlej daty)
*/
select
   0 as LP,
   REM_ZAS.SYMBOL as "Zasób",
   REM_ZGL.SYM as "Zgłoszenie",
   REM_ZGL.STAT_REJ as "Status",
   REM_ZGL.DT_WA as "Data zdarzenia",
   REM_ZGL.TM_WA as "Godzina zdarzenia",
   REM_ZGL.DT_ZAM as "Data zamknięcia",
   REM_ZGL.TM_ZAM as "Godzina zamknięcia",
   substr(to_string(REM_ZGL.DT_WA),1,7) as "Miesiąc",
   substr(to_string(REM_ZGL.DT_WA),1,4) as "Rok",
   1 as "Liczba zdarzeń",
   ( cast(REM_ZGL.DT_ZAM as REAL_TYPE)
     +cast(REM_ZGL.TM_ZAM as REAL_TYPE)/1440
     -cast(REM_ZGL.DT_WA as REAL_TYPE)
     -cast(REM_ZGL.TM_WA as REAL_TYPE)/1440
   ) as "Czas serwisu (dni)",
   sum(distinct REM_GRG.IL) as "Godziny",
   sum(distinct PROJ2FAP.W) as "Zakupy"
from
   REM_ZGL
   left join REM_ZAS
   left join @REM_GRG
   left join @PROJ2FAP
where
  (REM_ZGL.STAT_REJ in(:_a)) and
  ((REM_ZAS.SYMBOL like ':_b') or (':_b'='%' and REM_ZAS.SYMBOL is null)) and
  ((REM_ZGL.DT_WA between to_date(:_c) and to_date(:_d)) or
   (:_c='0000-0-0' and :_d='0000-0-0') or
   (REM_ZGL.DT_WA>to_date(:_c) and :_d='0000-0-0') or
   (REM_ZGL.DT_WA<to_date(:_d) and :_c='0000-0-0'))
group by
   REM_ZAS.SYMBOL, REM_ZGL.SYM, REM_ZGL.STAT_REJ, REM_ZGL.DT_WA, REM_ZGL.TM_WA, REM_ZGL.DT_ZAM, REM_ZGL.TM_ZAM
order by 3
