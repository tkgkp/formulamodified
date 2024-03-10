:!UTF-8
/* Parametry:
    _a - data przyjęcia reklamacji od (może być 0000/00/00, wtedy od dowolnej daty)
    _b - data przyjęcia reklamacji do (może być 0000/00/00, wtedy do dowonlej daty)
*/
select
   0 as LP,
   REK_N.SYM as "Symbol reklamacji",
   REK_R.KOD as "Rodzaj reklamacji",
   REK_N.ILDNI as "Ilość dni",
   REK_N.DP as "Data przyjęcia",
   REK_N.DZ as "Data zakończenia",
   REK_N.DX as "Data zamknięcia",
   KH.SKR as "Kontrahent",
   M.KTM as "Towar/usługa",
   M.N as "Nazwa",
   REK_N.IL as "Ilość",
   (cast(NVL(REK_N.DZ,SYSDATE) as REAL_TYPE)
     -cast(REK_N.DP as REAL_TYPE)
     +1
   ) as "Czas rozpatrzenia (dni)",
   CASE WHEN REK_N.DZ=TO_DATE('0000/00/00')
   THEN 0
   ELSE (cast(NVL(REK_N.DX,SYSDATE) as REAL_TYPE)
        -cast(REK_N.DZ as REAL_TYPE)
        +1)
   END as "Czas realizacji (dni)"
from
   REK_N left join REK_R left join KH join M
where
   (REK_N.SZ='Z')
   and ((REK_N.DP between to_date(:_a) and to_date(:_b)) or
   (:_a='0000-0-0' and :_b='0000-0-0') or
   (REK_N.DP>to_date(:_a) and :_b='0000-0-0') or
   (REK_N.DP<to_date(:_b) and :_a='0000-0-0'))
   and :_c
   and :_d